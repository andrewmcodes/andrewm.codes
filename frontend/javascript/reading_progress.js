// @ts-check
// A reading-progress rail and a back-to-top control for long posts.
//
// A 12,489px article gave a reader no sense of how much was left and no way
// back to the top but a swipe. Both are page-level status, so both live on the
// sticky bar's own edge rather than as a floating object over the prose.
import { onReady } from "./ready.js";

const MIN_HEIGHT = 2200; // Short posts need neither; they fit in a few screens.

function setup() {
  const article = document.querySelector("article.prose");
  if (!article) return;

  const doc = document.documentElement;
  if (doc.scrollHeight < MIN_HEIGHT) return;

  let bar = document.getElementById("reading-progress");
  if (!bar) {
    bar = document.createElement("div");
    bar.id = "reading-progress";
    // Presentational: the same information is available from the scrollbar,
    // and announcing a percentage on every scroll frame is noise.
    bar.setAttribute("aria-hidden", "true");
    document.body.appendChild(bar);
  }

  // Built in its own binding rather than assigned straight into `top`:
  // getElementById types that as HTMLElement, which has no `type`.
  let top = document.getElementById("back-to-top");
  if (!top) {
    const button = document.createElement("button");
    button.id = "back-to-top";
    button.type = "button";
    button.textContent = "Top";
    button.setAttribute("aria-label", "Back to top");
    button.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth" });
      document.querySelector("h1")?.focus?.();
    });
    document.body.appendChild(button);
    top = button;
  }

  const update = () => {
    const max = doc.scrollHeight - window.innerHeight;
    const ratio = max > 0 ? Math.min(1, Math.max(0, window.scrollY / max)) : 0;
    bar.style.transform = `scaleX(${ratio})`;
    top.dataset.visible = String(window.scrollY > window.innerHeight);
  };

  update();
  document.addEventListener("scroll", update, { passive: true });
  window.addEventListener("resize", update, { passive: true });
}

onReady(setup);
