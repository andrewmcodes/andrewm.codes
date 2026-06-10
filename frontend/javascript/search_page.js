// Standalone results page at /search/. Reads ?q=, queries the same
// /search.json the command palette uses, renders matches, and keeps ?q= in the
// URL so results are shareable and the WebSite SearchAction target works.
// Bails immediately on every other page.
const INDEX_URL = "/search.json";
const MAX_RESULTS = 30;
const DEBOUNCE_MS = 120;

function score(entry, terms) {
  const hay = `${entry.title} ${entry.tags || ""}`.toLowerCase();
  let total = 0;
  for (const term of terms) {
    const i = hay.indexOf(term);
    if (i === -1) return -1;
    total += i === 0 ? 5 : 1;
  }
  return total;
}

const esc = (s) =>
  String(s).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);

// Only allow http(s)/relative URLs so the index can never inject an active
// scheme (e.g. javascript:) into a result link.
function safeUrl(url) {
  const value = String(url || "");
  return /^(https?:|\/|#|\.)/i.test(value) ? value : "#";
}

async function initSearchPage() {
  const form = document.querySelector("[data-search-form]");
  const input = document.getElementById("search-input");
  const list = document.querySelector("[data-search-results]");
  const status = document.querySelector("[data-search-status]");
  if (!form || !input || !list || !status) return; // not the search page
  // Bind each form element only once. Turbo swaps <body> on navigation, so a
  // revisit gets a fresh (unbound) form; the immediate call + turbo:load on
  // first load no longer double-bind the listeners.
  if (form.dataset.bound === "true") return;
  form.dataset.bound = "true";

  let entries = [];
  try {
    const res = await fetch(INDEX_URL);
    entries = res.ok ? await res.json() : [];
  } catch {
    entries = [];
  }

  function render(q) {
    const query = q.trim().toLowerCase();
    if (!query) {
      list.innerHTML = "";
      status.textContent = "Type to search.";
      return;
    }
    const terms = query.split(/\s+/).filter(Boolean);
    const hits = entries
      .map((entry) => ({ entry, s: score(entry, terms) }))
      .filter((row) => row.s >= 0)
      .sort((a, b) => b.s - a.s)
      .slice(0, MAX_RESULTS)
      .map((row) => row.entry);

    status.textContent = `${hits.length} result${hits.length === 1 ? "" : "s"} for “${q.trim()}”`;
    list.innerHTML =
      hits
        .map(
          (r) => `
        <li>
          <a href="${esc(safeUrl(r.url))}" class="flex items-baseline gap-3 py-2.5 border-b border-sage-4 hover:text-mint-11 transition-colors">
            <span class="font-mono text-[10.5px] uppercase text-sage-10 w-16 shrink-0">${esc(r.kind || "page")}</span>
            <span class="flex-1 text-sage-12">${esc(r.title)}</span>
          </a>
        </li>`,
        )
        .join("") || `<li class="py-6 text-sage-10 text-sm">No matches.</li>`;
  }

  const initial = new URLSearchParams(location.search).get("q") || "";
  input.value = initial;
  render(initial);

  let debounce;
  input.addEventListener("input", () => {
    clearTimeout(debounce);
    debounce = setTimeout(() => {
      render(input.value);
      const url = new URL(location.href);
      if (input.value) url.searchParams.set("q", input.value);
      else url.searchParams.delete("q");
      history.replaceState(null, "", url);
    }, DEBOUNCE_MS);
  });
  form.addEventListener("submit", (e) => e.preventDefault());
}

document.addEventListener("turbo:load", initSearchPage);
initSearchPage();
