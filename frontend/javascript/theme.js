// Color-theme control: System / Light / Dark.
//
// "system" means no stored preference — we follow prefers-color-scheme and react
// to OS changes live. "light"/"dark" are explicit, persisted choices. The inline
// script in default.erb applies the resolved theme before paint; this module
// handles clicks, OS changes, and keeping the footer segmented control in sync
// (including after Turbo navigations + cached restores).
const STORAGE_KEY = "theme";

const systemTheme = () => (matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");

const currentMode = () => localStorage.getItem(STORAGE_KEY) || "system";

function applyTheme() {
  const mode = currentMode();
  document.documentElement.dataset.theme = mode === "system" ? systemTheme() : mode;
}

function syncControls() {
  const mode = currentMode();
  document.querySelectorAll("[data-theme-toggle]").forEach((group) => {
    const buttons = group.querySelectorAll("[data-theme-value]");
    buttons.forEach((btn) => {
      const checked = btn.dataset.themeValue === mode;
      btn.setAttribute("aria-checked", String(checked));
      // Roving tabindex: only the checked radio is a tab stop; arrows move
      // between the rest (WAI-ARIA radiogroup pattern).
      btn.tabIndex = checked ? 0 : -1;
    });
    // If nothing matched (shouldn't happen), keep the first reachable.
    if (![...buttons].some((b) => b.tabIndex === 0) && buttons[0]) buttons[0].tabIndex = 0;
  });
}

function selectValue(value) {
  if (value === "system") localStorage.removeItem(STORAGE_KEY);
  else localStorage.setItem(STORAGE_KEY, value);
  applyTheme();
  syncControls();
}

// Event delegation so the listener survives Turbo navigations + cached restores.
document.addEventListener("click", (e) => {
  const btn = e.target.closest("[data-theme-value]");
  if (!btn) return;
  selectValue(btn.dataset.themeValue);
});

// Arrow-key navigation within a radiogroup moves selection and focus.
document.addEventListener("keydown", (e) => {
  const btn = e.target.closest("[data-theme-toggle] [data-theme-value]");
  if (!btn) return;
  const group = btn.closest("[data-theme-toggle]");
  const buttons = [...group.querySelectorAll("[data-theme-value]")];
  const i = buttons.indexOf(btn);

  let next = null;
  if (e.key === "ArrowRight" || e.key === "ArrowDown") next = buttons[(i + 1) % buttons.length];
  else if (e.key === "ArrowLeft" || e.key === "ArrowUp") next = buttons[(i - 1 + buttons.length) % buttons.length];
  else if (e.key === " " || e.key === "Enter") next = btn;
  if (!next) return;

  e.preventDefault();
  selectValue(next.dataset.themeValue);
  next.focus();
});

// Follow the OS while in System mode. addEventListener isn't available on
// MediaQueryList in older Safari (<14), which only has addListener.
const mql = matchMedia("(prefers-color-scheme: dark)");
const onSystemChange = () => {
  if (currentMode() === "system") applyTheme();
};
if (mql.addEventListener) mql.addEventListener("change", onSystemChange);
else if (mql.addListener) mql.addListener(onSystemChange);

// Re-resolve the theme (not just the controls) on Turbo navigations and
// bfcache restores so System mode reflects an OS change that happened while a
// cached page was away.
const refresh = () => {
  applyTheme();
  syncControls();
};
document.addEventListener("turbo:load", refresh);
window.addEventListener("pageshow", refresh);
syncControls();
