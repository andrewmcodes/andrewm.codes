const colors = require("tailwindcss/colors")
const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  purge: {
    content: [
      "./assets/scripts/**/*.js",
      "./src/**/*.html",
      "./src/**/*.md",
      "./src/**/*.erb",
      "./src/**/*.*.erb",
      "./src/_components/**/*.rb",
    ],
    options: {
      safelist: [
        "text-blue-500",
        "text-yellow-500",
        "text-green-500",
        "text-gray-500",
        "border-blue-500",
        "border-gray-500",
        "border-green-500",
        "btn",
        "btn-outline",
        "btn-primary",
        "btn-large",
      ],
    },
  },
  darkMode: "media", // 'media' or 'class'
  theme: {
    colors: {
      yellow: colors.yellow,
      purple: colors.purple,
      blue: colors.blue,
      gray: colors.coolGray,
      red: colors.red,
      green: colors.green,
      pink: colors.pink,
      indigo: colors.indigo,
      white: "#fff",
    },
    lineClamp: {
      1: 1,
      2: 2,
      3: 3,
    },
    fontFamily: {
      sans: ["Inter", ...defaultTheme.fontFamily.sans],
      mono: ["JetBrains Mono", ...defaultTheme.fontFamily.mono],
    },
    extend: {
      colors: {
        gray: {
          1000: "#050505",
        },
      },
    },
  },
  variants: {
    extend: {
      borderWidth: ["hover", "focus"],
      textColor: ["visited"],
      textDecoration: ["dark"],
    },
  },
  plugins: [
    function ({ addBase, config }) {
      addBase({
        h1: { fontSize: config("theme.fontSize.4xl"), fontWeight: config("theme.fontWeight.extrabold") },
        h2: { fontSize: config("theme.fontSize.3xl"), fontWeight: config("theme.fontWeight.extrabold") },
        h3: { fontSize: config("theme.fontSize.2xl"), fontWeight: config("theme.fontWeight.bold") },
        h4: { fontSize: config("theme.fontSize.xl"), fontWeight: config("theme.fontWeight.bold") },
        h5: { fontSize: config("theme.fontSize.lg"), fontWeight: config("theme.fontWeight.bold") },
        h6: { fontSize: config("theme.fontSize.base"), fontWeight: config("theme.fontWeight.bold") },
      })
    },
    require("@tailwindcss/typography"),
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/forms"),
    require("tailwindcss-debug-screens"),
  ],
}
