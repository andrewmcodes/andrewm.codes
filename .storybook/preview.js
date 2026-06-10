import "../frontend/styles/index.css";

// Stories are pre-rendered HTML fragments from the real Ruby components
// (output/stories/*). Wrap each in the site's dark theme + surface so the
// Sage/Mint design tokens resolve (they're scoped to [data-theme]).
/** @type {import('@storybook/html-vite').Preview} */
const preview = {
  parameters: {
    layout: "fullscreen",
  },
  decorators: [
    (story) => `<div data-theme="dark" class="bg-sage-1 text-sage-12 font-sans p-8 min-h-screen">${story()}</div>`,
  ],
};

export default preview;
