module.exports = {
  plugins: {
    tailwindcss: {},
    "postcss-focus-visible": {
      replaceWith: "[data-focus-visible-added]"
    },
    autoprefixer: {},
    ...(process.env.NODE_ENV === "production" || process.env.VERCEL_ENV === "preview" ? { cssnano: {} } : {})
  }
}
