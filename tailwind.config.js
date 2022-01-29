const { fontFamily } = require("tailwindcss/defaultTheme")

module.exports = {
  content: ["./src/**/*.{md,rb,erb,html}", "./frontend/javascript/**/*.js"],
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
        sans: ["IBM Plex Sans", ...fontFamily.sans]
        // mono: ["IBM Plex Sans", ...fontFamily.mono]
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
