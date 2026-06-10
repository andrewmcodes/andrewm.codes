// @ts-check
// Web Share API. Delegation pattern so it works after Turbo nav + restore.
import { onReady } from "./ready.js";

if (navigator.share) {
  onReady(() => {
    document.querySelectorAll("button.share-btn").forEach((btn) => {
      /** @type {HTMLElement} */ (btn).hidden = false;
    });
  });

  document.addEventListener("click", async (e) => {
    const target = e.target;
    if (!(target instanceof Element)) return;
    const btn = /** @type {HTMLElement | null} */ (target.closest("button.share-btn"));
    if (!btn) return;
    try {
      await navigator.share({
        title: btn.dataset.shareTitle,
        url: btn.dataset.shareUrl,
      });
    } catch (err) {
      // The user dismissing the share sheet rejects with an AbortError; only
      // surface anything else.
      if (/** @type {{ name?: string }} */ (err).name !== "AbortError") console.error(err);
    }
  });
}
