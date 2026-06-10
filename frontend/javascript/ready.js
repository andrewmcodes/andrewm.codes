// @ts-check
// Run `fn` after initial load AND on every Turbo page swap.
// Turbo replaces the body, so element-level event listeners need re-binding.
// Use `data-bound` to make handlers idempotent.
/** @param {() => void} fn */
export function onReady(fn) {
  if (document.readyState !== "loading") {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn, { once: true });
  }
  document.addEventListener("turbo:load", fn);
}
