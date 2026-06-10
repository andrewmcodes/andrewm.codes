module.exports = {
  // Token from https://torchlight.dev. Loaded via fnox + mise in dev, set as
  // a Cloudflare Pages / CI env var in deploys.
  token: process.env.TORCHLIGHT_TOKEN,

  // Cache built blocks locally so repeated runs are fast.
  cache: ".torchlight-cache",

  // VS Code theme — see https://torchlight.dev/docs/themes
  theme: "one-dark-pro",

  host: "https://api.torchlight.dev",

  options: {
    lineNumbers: false,
    diffIndicators: true,
    diffIndicatorsInPlaceOfLineNumbers: true,
  },

  highlight: {
    input: "./output",
    output: "",
    includeGlobs: ["**/*.htm", "**/*.html"],
    excludePatterns: ["/node_modules/", "/vendor/", "/_bridgetown/"],
  },
};
