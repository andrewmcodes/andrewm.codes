// Mobile navigation: the trigger toggles an animated panel + backdrop.
// Event delegation so the toggle keeps working after Turbo navigations.
const MENU_ID = "mobile-menu";
const BACKDROP_ID = "mobile-menu-backdrop";
const TRIGGER_ID = "mobile-menu-trigger";
const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])';

// The element focus returns to when the menu closes.
let lastFocused = null;

function menuFocusables(menu) {
  return Array.from(menu.querySelectorAll(FOCUSABLE)).filter(
    (node) => !node.hasAttribute("hidden") && node.offsetParent !== null,
  );
}

// Move focus to the first menu item on open. The panel hides via inert+opacity
// (not visibility), so its items are focusable as soon as inert is lifted.
function focusFirstItem(menu) {
  const first = Array.from(menu.querySelectorAll(FOCUSABLE)).find((node) => !node.hasAttribute("hidden"));
  first?.focus();
}

function setOpen(open) {
  const menu = document.getElementById(MENU_ID);
  if (!menu) return;

  // Remember where focus came from before the first open.
  if (open && menu.dataset.open !== "true") lastFocused = document.activeElement;

  menu.dataset.open = String(open);
  // The panel is always rendered (hidden via opacity), so `inert` is what keeps
  // it out of the tab order + accessibility tree while closed.
  menu.inert = !open;

  const backdrop = document.getElementById(BACKDROP_ID);
  if (backdrop) backdrop.dataset.open = String(open);

  const btn = document.getElementById(TRIGGER_ID);
  if (btn) {
    btn.setAttribute("aria-expanded", String(open));
    btn.setAttribute("aria-label", open ? "Close menu" : "Open menu");
    const openIcon = btn.querySelector('[data-menu-icon="open"]');
    const closeIcon = btn.querySelector('[data-menu-icon="close"]');
    if (openIcon) openIcon.hidden = open;
    if (closeIcon) closeIcon.hidden = !open;
  }

  if (open) {
    requestAnimationFrame(() => focusFirstItem(menu));
  } else if (lastFocused) {
    lastFocused.focus();
    lastFocused = null;
  }
}

function isOpen() {
  const menu = document.getElementById(MENU_ID);
  return menu?.dataset.open === "true";
}

document.addEventListener("click", (e) => {
  if (e.target.closest(`#${TRIGGER_ID}`)) {
    setOpen(!isOpen());
    return;
  }

  if (!isOpen()) return;

  // Tapping the backdrop or following a menu link closes the menu. Theme-toggle
  // buttons inside the footer are not links, so they leave the menu open.
  if (e.target.closest(`#${BACKDROP_ID}`) || e.target.closest(`#${MENU_ID} a`)) {
    setOpen(false);
  }
});

document.addEventListener("keydown", (e) => {
  if (!isOpen()) return;

  if (e.key === "Escape") {
    setOpen(false);
    return;
  }

  // Trap Tab within the open panel.
  if (e.key === "Tab") {
    const menu = document.getElementById(MENU_ID);
    const items = menuFocusables(menu);
    if (!items.length) return;
    const first = items[0];
    const last = items[items.length - 1];
    const active = document.activeElement;
    if (e.shiftKey && (active === first || !menu.contains(active))) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && (active === last || !menu.contains(active))) {
      e.preventDefault();
      first.focus();
    }
  }
});

// Close the mobile menu when the user starts scrolling. Only fires if the
// menu is actually open to avoid the listener doing work on every scroll.
let lastScrollY = window.scrollY;
document.addEventListener(
  "scroll",
  () => {
    if (!isOpen()) {
      lastScrollY = window.scrollY;
      return;
    }
    if (Math.abs(window.scrollY - lastScrollY) > 8) setOpen(false);
    lastScrollY = window.scrollY;
  },
  { passive: true },
);
