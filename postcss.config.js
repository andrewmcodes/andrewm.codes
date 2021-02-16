const postcssPresetEnv = require("postcss-preset-env")
const tailwind = require("tailwindcss")
const autoprefixer = require("autoprefixer")
const cssnano = require("cssnano")
const flexbugs = require("postcss-flexbugs-fixes")
const isProd = process.env.NODE_ENV === "production"

module.exports = {
  plugins: [
    postcssPresetEnv({
      /* use stage 3 features + css nesting rules */
      // stage: 3,
      features: {
        "nesting-rules": true,
      },
    }),
    tailwind,
    flexbugs,
    autoprefixer,
    isProd ? cssnano : false,
  ],
}
