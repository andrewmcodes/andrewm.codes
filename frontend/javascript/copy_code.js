// @ts-check
// Adds a Copy button to every <pre><code>. Click uses event delegation
// so listeners survive Turbo navigations + cached restores.
import { onReady } from "./ready.js";

onReady(() => {
  document.querySelectorAll("pre > code").forEach((code) => {
    const pre = code.parentElement;
    if (!pre) return;
    // Check by DOM presence so we don't double-append on cached restore.
    if (pre.querySelector(":scope > button.copy-code")) return;
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "copy-code";
    btn.textContent = "Copy";
    pre.appendChild(btn);
  });
});

document.addEventListener("click", async (e) => {
  const target = e.target;
  if (!(target instanceof Element)) return;
  const btn = target.closest("button.copy-code");
  if (!btn) return;
  const code = btn.parentElement?.querySelector("code");
  if (!code) return;
  // navigator.clipboard is unavailable on insecure origins and can reject if
  // permission is denied; don't leave the button stuck or throw uncaught.
  try {
    await navigator.clipboard.writeText(code.textContent ?? "");
    btn.textContent = "Copied";
  } catch {
    btn.textContent = "Copy failed";
  }
  setTimeout(() => (btn.textContent = "Copy"), 1500);
});
