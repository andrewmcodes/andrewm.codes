const { fontFamily } = require("tailwindcss/defaultTheme")

module.exports = {
  content: ["./src/**/*.{md,rb,erb,html}"],
  darkMode: "class",
  theme: {
    container: {
      center: true,
      padding: "1rem"
    },
    extend: {
      textColor: {
        skin: {
          DEFAULT: "var(--text)",
          primary: "var(--primary)",
          "primary-light": "var(--primary-light)",
          muted: "var(--text-muted)",
          inverted: "var(--text-inverted)",
          code: "var(--text-code)"
        }
      },
      backgroundColor: {
        skin: {
          DEFAULT: "var(--page)",
          code: "var(--code)",
          inverted: "var(--page-inverted)",
          primary: "var(--primary-dark)",
          "primary-light": "var(--primary-light)",
          nav: "var(--nav-bg)"
        }
      },
      textDecorationColor: {
        skin: {
          primary: "var(--primary)"
        }
      },
      borderColor: {
        skin: {
          DEFAULT: "var(--divider)",
          divider: "var(--divider)",
          primary: "var(--primary)"
        }
      },
      ringColor: {
        skin: {
          primary: "var(--primary)"
        }
      },
      divideColor: {
        skin: {
          base: "var(--divider)"
        }
      },
      fontFamily: {
        ...fontFamily,
        sans: ["iA Writer Quattro", ...fontFamily.sans],
        mono: ["iA Writer Quattro", ...fontFamily.mono]
      },
      typography: _theme => ({
        DEFAULT: {
          css: {
            maxWidth: "75ch"
            // "a[rel*='noopener']::after": {
            //   content: '"↗"',
            //   marginLeft: "2px"
            // }
          }
        }
      })
    }
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/forms"),
    require("tailwindcss-debug-screens")
  ]
}
