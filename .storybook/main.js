/** @type {import('@storybook/html-vite').StorybookConfig} */
const config = {
  framework: "@storybook/html-vite",
  // CSF files raw-import the HTML rendered by Bridgetown into output/stories/*,
  // so run a Bridgetown build before Storybook (see the `storybook` mise task).
  stories: ["../stories/**/*.stories.js"],
};

export default config;
