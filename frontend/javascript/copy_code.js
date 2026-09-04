// @ts-check
// Adds a Copy button to every <pre><code>. Click uses event delegation
// so listeners survive Turbo navigations + cached restores.
import { onReady } from "./ready.js";

// The <pre> is the horizontal scroll container, so a button positioned against
// it scrolls out of view the moment a wide line is panned — exactly when a
// reader most wants to copy rather than read across. Each <pre> is wrapped in a
// non-scrolling element, and the button is positioned against that instead.
/**
 * @param {HTMLElement} pre
 * @returns {HTMLElement} the non-scrolling wrapper around `pre`
 */
function wrapperFor(pre) {
  const parent = pre.parentElement;
  if (parent && parent.classList.contains("code-block")) return parent;
  const wrap = document.createElement("div");
  wrap.className = "code-block";
  parent?.insertBefore(wrap, pre);
  wrap.appendChild(pre);
  return wrap;
}

// A block that scrolls sideways gets a fade on the edge it scrolls toward, so
// a clipped line never just stops mid-token. Recomputed on scroll and on
// resize, because whether a block overflows is a function of the viewport.
/**
 * @param {HTMLElement} wrap
 * @param {HTMLElement} pre
 */
function trackOverflow(wrap, pre) {
  const update = () => {
    const remaining = pre.scrollWidth - pre.clientWidth - pre.scrollLeft;
    wrap.dataset.overflow = String(remaining > 2);
  };
  update();
  pre.addEventListener("scroll", update, { passive: true });
  window.addEventListener("resize", update, { passive: true });
}

onReady(() => {
  document.querySelectorAll("pre > code").forEach((code) => {
    const pre = code.parentElement;
    if (!pre) return;
    const wrap = wrapperFor(pre);
    // A <pre> that scrolls sideways is a scrollable region, and a keyboard user
    // has to be able to reach and pan it. Tab lands on the block itself.
    if (!pre.hasAttribute("tabindex")) {
      pre.setAttribute("tabindex", "0");
      pre.setAttribute("role", "region");
      const lang = pre.closest("[class*=language-]");
      const name = lang && (lang.className.match(/language-([\w+-]+)/) || [])[1];
      pre.setAttribute("aria-label", name ? name + " code" : "Code");
      if (name) wrap.dataset.lang = name;
    }
    // Check by DOM presence so we don't double-append on cached restore.
    if (wrap.querySelector(":scope > button.copy-code")) return;
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "copy-code";
    btn.textContent = "Copy";
    btn.setAttribute("aria-label", wrap.dataset.lang ? "Copy " + wrap.dataset.lang + " code" : "Copy code");
    wrap.appendChild(btn);
    trackOverflow(wrap, pre);
  });
});

/** Pending label resets, keyed by button, so a second copy doesn't get cut
 * short by the first one's timer.
 * @type {WeakMap<Element, ReturnType<typeof setTimeout>>} */
const resets = new WeakMap();

document.addEventListener("click", async (e) => {
  const target = e.target;
  if (!(target instanceof Element)) return;
  const btn = target.closest("button.copy-code");
  if (!btn) return;
  const code = btn.parentElement?.querySelector("code");
  if (!code) return;
  clearTimeout(resets.get(btn));
  // navigator.clipboard is unavailable on insecure origins and can reject if
  // permission is denied; don't leave the button stuck or throw uncaught.
  try {
    await navigator.clipboard.writeText(code.textContent ?? "");
    btn.textContent = "Copied";
    // Nothing visible happens when text reaches the clipboard, so the button
    // takes the accent for the length of the confirmation.
    btn.setAttribute("data-copied", "");
  } catch {
    // Clipboard access is refused on insecure origins and when the permission
    // is denied. Naming the way out beats naming the failure.
    btn.textContent = "Select to copy";
    const pre = btn.parentElement?.querySelector("pre");
    if (pre) {
      pre.focus();
      const range = document.createRange();
      range.selectNodeContents(code);
      const selection = window.getSelection();
      selection?.removeAllRanges();
      selection?.addRange(range);
    }
  }
  resets.set(
    btn,
    setTimeout(() => {
      btn.textContent = "Copy";
      btn.removeAttribute("data-copied");
    }, 2000),
  );
});
