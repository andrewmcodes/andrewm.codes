// @ts-check
// Command palette over a static search.json built by Builders::SearchIndex.
// Opens with ⌘K / Ctrl+K or the topbar search button. All event bindings live
// on document so they survive Turbo navigations including back-button restore.

/**
 * @typedef {Object} SearchEntry
 * @property {string} url
 * @property {string} title
 * @property {string} [kind]
 * @property {string} [tags]
 * @property {boolean} [pinned]
 */

const MAX_RESULTS = 12;
const INDEX_URL = "/search.json";

/** @type {Promise<SearchEntry[]> | null} */
let indexPromise = null;
/** @type {SearchEntry[]} */
let entries = [];
let selectedIdx = 0;
/** @type {SearchEntry[]} */
let results = [];
let searchToken = 0;
// The element focus returns to when the palette closes.
/** @type {HTMLElement | null} */
let lastFocused = null;

const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])';

/**
 * Narrow an event target to an Element (events can fire on Document/Window).
 * @param {EventTarget | null} t
 * @returns {Element | null}
 */
const asElement = (t) => (t instanceof Element ? t : null);

// Only allow http(s) and relative URLs into href/navigation so a future index
// entry can never smuggle in a `javascript:` (or other active) scheme.
/** @param {string | undefined} url */
function safeUrl(url) {
  const value = String(url || "");
  if (/^(https?:|\/|#|\.)/i.test(value)) return value;
  return "#";
}

function loadIndex() {
  if (indexPromise) return indexPromise;
  indexPromise = fetch(INDEX_URL)
    .then((res) => (res.ok ? res.json() : []))
    .then((data) => {
      entries = Array.isArray(data) ? data : [];
      return entries;
    })
    .catch((err) => {
      console.warn("search.json unavailable:", err);
      entries = [];
      return entries;
    });
  return indexPromise;
}

/** @param {string} id */
const el = (id) => document.getElementById(id);

function pinnedEntries() {
  return entries.filter((e) => e.pinned);
}

function openCmdk() {
  const overlay = el("cmdk");
  if (!overlay) return;
  lastFocused = /** @type {HTMLElement | null} */ (document.activeElement);
  overlay.hidden = false;
  const input = /** @type {HTMLInputElement | null} */ (el("cmdk-input"));
  if (input) {
    input.value = "";
    setTimeout(() => input.focus(), 10);
  }
  loadIndex().then(() => renderResults(pinnedEntries()));
}

function closeCmdk() {
  const overlay = el("cmdk");
  if (overlay) overlay.hidden = true;
  const input = el("cmdk-input");
  if (input) input.removeAttribute("aria-activedescendant");
  if (lastFocused) {
    lastFocused.focus();
    lastFocused = null;
  }
}

/** @param {SearchEntry[]} items */
function renderResults(items) {
  results = items;
  selectedIdx = 0;
  const list = el("cmdk-results");
  if (!list) return;
  if (!items.length) {
    list.innerHTML = `<div class="px-[18px] py-8 text-center text-[13.5px] text-sage-10">No matches.</div>`;
    el("cmdk-input")?.removeAttribute("aria-activedescendant");
    return;
  }
  list.innerHTML = items
    .map(
      (r, i) => `
    <a href="${escapeHTML(safeUrl(r.url))}" id="cmdk-opt-${i}" role="option" aria-selected="${i === 0}" data-cmdk-item data-idx="${i}" class="flex items-center gap-3 px-[18px] py-2 text-sm cursor-pointer ${i === 0 ? "bg-sage-3" : ""}">
      <span class="font-mono text-[10.5px] uppercase text-sage-10 w-16 shrink-0">${escapeHTML(r.kind || "page")}</span>
      <span class="flex-1 ${i === 0 ? "text-mint-11" : "text-sage-12"}">${escapeHTML(r.title)}</span>
    </a>
  `,
    )
    .join("");
  el("cmdk-input")?.setAttribute("aria-activedescendant", "cmdk-opt-0");
}

function updateSelection() {
  const list = el("cmdk-results");
  if (!list) return;
  list.querySelectorAll("[data-cmdk-item]").forEach((node, i) => {
    const title = node.querySelector("span:nth-child(2)");
    const selected = i === selectedIdx;
    node.setAttribute("aria-selected", String(selected));
    if (selected) {
      node.classList.add("bg-sage-3");
      title?.classList.add("text-mint-11");
      title?.classList.remove("text-sage-12");
      node.scrollIntoView({ block: "nearest" });
      el("cmdk-input")?.setAttribute("aria-activedescendant", node.id);
    } else {
      node.classList.remove("bg-sage-3");
      title?.classList.remove("text-mint-11");
      title?.classList.add("text-sage-12");
    }
  });
}

/** @param {SearchEntry} entry @param {string[]} terms */
function scoreEntry(entry, terms) {
  const haystack = `${entry.title} ${entry.tags || ""}`.toLowerCase();
  let score = 0;
  for (const term of terms) {
    const i = haystack.indexOf(term);
    if (i === -1) return -1;
    score += i === 0 ? 5 : 1;
    if (entry.pinned) score += 2;
  }
  return score;
}

/** @param {string} q */
async function runSearch(q) {
  const token = ++searchToken;
  await loadIndex();
  if (token !== searchToken) return;

  const query = q.trim().toLowerCase();
  if (!query) {
    renderResults(pinnedEntries());
    return;
  }

  const terms = query.split(/\s+/).filter(Boolean);
  const scored = entries
    .map((e) => ({ entry: e, score: scoreEntry(e, terms) }))
    .filter((row) => row.score >= 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, MAX_RESULTS)
    .map((row) => row.entry);

  renderResults(scored);
}

/** @param {string} s */
function escapeHTML(s) {
  return String(s).replace(
    /[&<>"']/g,
    (c) =>
      ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;",
      })[c] ?? c,
  );
}

document.addEventListener("click", (e) => {
  const target = asElement(e.target);
  if (!target) return;
  if (target.closest("#cmdk-trigger")) {
    openCmdk();
    return;
  }
  if (target.closest("[data-cmdk-item]")) {
    closeCmdk();
    return;
  }
  if (target.id === "cmdk") closeCmdk();
});

document.addEventListener("mouseover", (e) => {
  const item = /** @type {HTMLElement | null} */ (asElement(e.target)?.closest("[data-cmdk-item]") ?? null);
  if (!item) return;
  const idx = parseInt(item.dataset.idx ?? "", 10);
  if (Number.isNaN(idx)) return;
  selectedIdx = idx;
  updateSelection();
});

document.addEventListener("input", (e) => {
  const target = asElement(e.target);
  if (target && target.id === "cmdk-input") {
    runSearch(/** @type {HTMLInputElement} */ (target).value);
  }
});

document.addEventListener("keydown", (e) => {
  const overlay = el("cmdk");
  const isOpen = !!overlay && !overlay.hidden;

  if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
    e.preventDefault();
    isOpen ? closeCmdk() : openCmdk();
    return;
  }

  if (!isOpen || !overlay) return;

  if (e.key === "Escape") {
    e.preventDefault();
    closeCmdk();
    return;
  }
  // Trap Tab within the dialog so focus can't escape to the page behind it.
  if (e.key === "Tab") {
    const items = /** @type {HTMLElement[]} */ (Array.from(overlay.querySelectorAll(FOCUSABLE))).filter(
      (node) => node.offsetParent !== null,
    );
    if (items.length) {
      const first = items[0];
      const last = items[items.length - 1];
      const active = document.activeElement;
      if (e.shiftKey && (active === first || !overlay.contains(active))) {
        e.preventDefault();
        last.focus();
      } else if (!e.shiftKey && (active === last || !overlay.contains(active))) {
        e.preventDefault();
        first.focus();
      }
    }
    return;
  }
  if (e.key === "ArrowDown") {
    e.preventDefault();
    selectedIdx = Math.min(selectedIdx + 1, results.length - 1);
    updateSelection();
    return;
  }
  if (e.key === "ArrowUp") {
    e.preventDefault();
    selectedIdx = Math.max(selectedIdx - 1, 0);
    updateSelection();
    return;
  }
  if (e.key === "Enter") {
    e.preventDefault();
    const r = results[selectedIdx];
    if (r) {
      window.location.href = safeUrl(r.url);
      closeCmdk();
    }
  }
});
