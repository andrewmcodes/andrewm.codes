// @ts-check
// "Copy page" button + Markdown dropdown for posts. Fetches the page's
// Markdown twin (.md) and copies it to the clipboard. Pure event delegation,
// so it survives Turbo navigations and cached restores.

/** @param {Element} button */
async function copyPage(button) {
  const root = /** @type {HTMLElement | null} */ (button.closest(".md-actions"));
  const label = button.querySelector(".md-copy-label");
  const url = root?.dataset.mdUrl;
  if (!url || !label) return;

  // navigator.clipboard is unavailable on insecure origins and can reject if
  // permission is denied; never leave the button stuck or throw uncaught.
  try {
    const response = await fetch(url, {
      headers: { Accept: "text/markdown, text/plain" },
    });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    await navigator.clipboard.writeText(await response.text());
    label.textContent = "Copied";
  } catch {
    label.textContent = "Copy failed";
  }
  setTimeout(() => (label.textContent = "Copy page"), 1500);
}

document.addEventListener("click", (e) => {
  const target = e.target;
  if (!(target instanceof Element)) return;
  const copyButton = target.closest(".md-actions .md-copy");
  if (copyButton) {
    copyPage(copyButton);
    return;
  }

  // Close any open Markdown dropdown when clicking outside it, or after
  // picking one of its links.
  document.querySelectorAll("details.md-menu[open]").forEach((menu) => {
    if (!menu.contains(target) || target.closest(".md-menu a")) {
      /** @type {HTMLDetailsElement} */ (menu).open = false;
    }
  });
});
