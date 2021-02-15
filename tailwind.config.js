const colors = require("tailwindcss/colors")
const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  purge: {
    content: ["./frontend/**/*.js", "./src/**/*.html", "./src/**/*.md", "./src/**/*.erb", "./src/_components/**/*.rb"],
    options: {
      safelist: [
        "text-blue-500",
        "text-yellow-500",
        "text-green-500",
        "text-gray-500",
        "border-blue-500",
        "border-gray-500",
        "border-green-500",
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
      sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      mono: ["JetBrains Mono", ...defaultTheme.fontFamily.mono],
    },
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            blockQuote: {
              fontWeight: "400",
            },
            img: {
              borderRadius: "8px",
            },
            h4: {
              fontSize: "1.5rem",
              fontWeight: "800",
            },
            h5: {
              fontSize: "1.3rem",
              marginTop: "2.5rem",
              marginBottom: "-0.75rem",
            },
            a: {
              fontWeight: "600",
            },
          },
        },
      }),
      colors: {
        "gray-1000": "#050505",
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
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("tailwindcss-line-clamp"),
    require("tailwindcss-debug-screens"),
  ],
}
