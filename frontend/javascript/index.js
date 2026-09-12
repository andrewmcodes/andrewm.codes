import "$styles/index.css";
import "@hotwired/turbo";
import "@fontsource-variable/geist";
import "@fontsource-variable/geist-mono";
import "./cmdk.js";
import "./theme.js";
import "./mobile_menu.js";
import { onReady } from "./ready.js";

// Interaction modules are fetched only after their matching UI appears. This
// runs again after Turbo swaps the body, while import() keeps each module a
// single cached download for the lifetime of the page.
const pageModules = [
  ["[data-search-form]", () => import("./search_page.js")],
  ["[data-archive]", () => import("./archive_filter.js")],
  ["[data-section-index]", () => import("./section_index.js")],
  ["button.share-btn", () => import("./share.js")],
  ["pre > code", () => import("./copy_code.js")],
  [".md-actions", () => import("./copy_page.js")],
  ["[data-toc]", () => import("./toc.js")],
  ["[data-reading-progress]", () => import("./reading_progress.js")],
];

onReady(() => {
  pageModules.forEach(([selector, load]) => {
    if (document.querySelector(selector)) load();
  });
});
