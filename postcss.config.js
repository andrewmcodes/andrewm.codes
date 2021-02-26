const postcssPresetEnv = require("postcss-preset-env")
const tailwind = require("tailwindcss")
const autoprefixer = require("autoprefixer")
const cssnano = require("cssnano")
const flexbugs = require("postcss-flexbugs-fixes")
const postcssNested = require("postcss-nested")
const postcssNestedAncestors = require("postcss-nested-ancestors")
const isProd = process.env.NODE_ENV === "production"

module.exports = {
  plugins: [
    tailwind(),
    postcssNested(),
    postcssNestedAncestors(),
    postcssPresetEnv({
      features: {
        "nesting-rules": true,
      },
    }),
    flexbugs(),
    autoprefixer(),
    isProd ? cssnano() : false,
  ],
}
