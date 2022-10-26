const defaultTheme = require("tailwindcss/defaultTheme")

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,md,liquid,erb,serb,rb}", "./frontend/javascript/**/*.js"],
  darkMode: "class",
  plugins: [
    require("radix-colors-for-tailwind")({
      colors: ["slate", "blue", "cyan", "amber", "red", "violet"]
    }),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
    require("tailwindcss-debug-screens")
  ],
  theme: {
    debugScreens: {
      position: ["bottom", "right"]
    },
    fontSize: {
      xs: ["0.8125rem", { lineHeight: "1.5rem" }], // 13, 24
      sm: ["0.875rem", { lineHeight: "1.5rem" }], // 14, 24
      base: ["1rem", { lineHeight: "1.75rem" }], // 16, 28
      lg: ["1.125rem", { lineHeight: "1.75rem" }], // 18, 28
      xl: ["1.25rem", { lineHeight: "2rem" }], // 20, 32
      "2xl": ["1.5rem", { lineHeight: "2rem" }], // 24, 32
      "3xl": ["1.875rem", { lineHeight: "2.25rem" }], // 30, 36
      "4xl": ["2rem", { lineHeight: "2.5rem" }], // 32, 40
      "5xl": ["2.5rem", { lineHeight: "2.5rem" }], // 32, 40
      "6xl": ["3rem", { lineHeight: "3.5rem" }], // 48, 56
      "7xl": ["3.75rem", { lineHeight: "1" }], // 60, 16
      "8xl": ["4.5rem", { lineHeight: "1" }], // 72, 16
      "9xl": ["6rem", { lineHeight: "1" }] // 96, 16
    },
    typography: theme => ({
      warning: {
        css: {
          "--tw-prose-body": theme("colors.radix.amber12"),
          "--tw-prose-headings": theme("colors.radix.amber12"),
          "--tw-prose-links": theme("colors.radix.amber11"),
          "--tw-prose-links-hover": theme("colors.radix.amber11"),
          "--tw-prose-underline": theme("colors.radix.amber7"),
          "--tw-prose-underline-hover": theme("colors.radix.amber8"),
          "--tw-prose-bold": theme("colors.radix.amber12"),
          "--tw-prose-counters": theme("colors.radix.amber11"),
          "--tw-prose-bullets": theme("colors.radix.amber6"),
          "--tw-prose-hr": theme("colors.radix.amber6"),
          "--tw-prose-quote-borders": theme("colors.radix.amber6"),
          "--tw-prose-captions": theme("colors.radix.amber11"),
          "--tw-prose-code": theme("colors.radix.amber12"),
          "--tw-prose-code-bg": theme("colors.radix.amber3"),
          "--tw-prose-pre-code": theme("colors.radix.amber12"),
          "--tw-prose-pre-bg": theme("colors.radix.amber3"),
          "--tw-prose-pre-border": theme("colors.radix.amber6"),
          "--tw-prose-th-borders": theme("colors.radix.amber6"),
          "--tw-prose-td-borders": theme("colors.radix.amber6")
        }
      },
      invert: {
        css: {
          "--tw-prose-body": "var(--tw-prose-invert-body)",
          "--tw-prose-headings": "var(--tw-prose-invert-headings)",
          "--tw-prose-links": "var(--tw-prose-invert-links)",
          "--tw-prose-links-hover": "var(--tw-prose-invert-links-hover)",
          "--tw-prose-underline": "var(--tw-prose-invert-underline)",
          "--tw-prose-underline-hover": "var(--tw-prose-invert-underline-hover)",
          "--tw-prose-bold": "var(--tw-prose-invert-bold)",
          "--tw-prose-counters": "var(--tw-prose-invert-counters)",
          "--tw-prose-bullets": "var(--tw-prose-invert-bullets)",
          "--tw-prose-hr": "var(--tw-prose-invert-hr)",
          "--tw-prose-quote-borders": "var(--tw-prose-invert-quote-borders)",
          "--tw-prose-captions": "var(--tw-prose-invert-captions)",
          "--tw-prose-code": "var(--tw-prose-invert-code)",
          "--tw-prose-code-bg": "var(--tw-prose-invert-code-bg)",
          "--tw-prose-pre-code": "var(--tw-prose-invert-pre-code)",
          "--tw-prose-pre-bg": "var(--tw-prose-invert-pre-bg)",
          "--tw-prose-pre-border": "var(--tw-prose-invert-pre-border)",
          "--tw-prose-th-borders": "var(--tw-prose-invert-th-borders)",
          "--tw-prose-td-borders": "var(--tw-prose-invert-td-borders)"
        }
      },
      DEFAULT: {
        css: {
          "--tw-prose-body": theme("colors.radix.slate11"),
          "--tw-prose-headings": theme("colors.radix.slate12"),
          "--tw-prose-links": theme("colors.radix.blue11"),
          "--tw-prose-links-hover": theme("colors.radix.blue11"),
          "--tw-prose-underline": theme("colors.radix.blue7"),
          "--tw-prose-underline-hover": theme("colors.radix.blue8"),
          "--tw-prose-bold": theme("colors.radix.slate12"),
          "--tw-prose-counters": theme("colors.radix.slate11"),
          "--tw-prose-bullets": theme("colors.radix.slate11"),
          "--tw-prose-hr": theme("colors.radix.slate6"),
          "--tw-prose-quote-borders": theme("colors.radix.slate7"),
          "--tw-prose-captions": theme("colors.radix.slate11"),
          "--tw-prose-code": theme("colors.radix.slate12"),
          "--tw-prose-code-bg": theme("colors.radix.slate3"),
          "--tw-prose-pre-code": theme("colors.radix.slate12"),
          "--tw-prose-pre-bg": theme("colors.radix.slate3"),
          "--tw-prose-pre-border": theme("colors.radix.slate6"),
          "--tw-prose-th-borders": theme("colors.radix.slate6"),
          "--tw-prose-td-borders": theme("colors.radix.slate6"),
          "--tw-prose-invert-body": theme("colors.radix.slate11"),
          "--tw-prose-invert-headings": theme("colors.radix.slate12"),
          "--tw-prose-invert-links": theme("colors.radix.blue11"),
          "--tw-prose-invert-links-hover": theme("colors.radix.blue11"),
          "--tw-prose-invert-underline": theme("colors.radix.blue7"),
          "--tw-prose-invert-underline-hover": theme("colors.radix.blue8"),
          "--tw-prose-invert-bold": theme("colors.radix.slate12"),
          "--tw-prose-invert-counters": theme("colors.radix.slate11"),
          "--tw-prose-invert-bullets": theme("colors.radix.slate12"),
          "--tw-prose-invert-hr": theme("colors.radix.slate6"),
          "--tw-prose-invert-quote-borders": theme("colors.radix.slate6"),
          "--tw-prose-invert-captions": theme("colors.radix.slate11"),
          "--tw-prose-invert-code": theme("colors.radix.slate12"),
          "--tw-prose-invert-code-bg": theme("colors.radix.slate3"),
          "--tw-prose-invert-pre-code": theme("colors.radix.slate12"),
          "--tw-prose-invert-pre-bg": theme("colors.radix.slate3"),
          "--tw-prose-invert-pre-border": "transparent",
          "--tw-prose-invert-th-borders": theme("colors.radix.slate6"),
          "--tw-prose-invert-td-borders": theme("colors.radix.slate6"),

          // Base
          color: "var(--tw-prose-body)",
          maxWidth: "65ch",
          lineHeight: theme("lineHeight.7"),
          "> *": {
            marginTop: theme("spacing.10"),
            marginBottom: theme("spacing.10")
          },
          p: {
            marginTop: theme("spacing.7"),
            marginBottom: theme("spacing.7")
          },

          // Headings
          "h2, h3": {
            color: "var(--tw-prose-headings)",
            fontWeight: theme("fontWeight.semibold")
          },
          h2: {
            fontSize: theme("fontSize.xl")[0],
            lineHeight: theme("lineHeight.7"),
            marginTop: theme("spacing.16"),
            marginBottom: theme("spacing.4")
          },
          h3: {
            fontSize: theme("fontSize.base")[0],
            lineHeight: theme("lineHeight.7"),
            marginTop: theme("spacing.12"),
            marginBottom: theme("spacing.4")
          },
          ":is(h2, h3) + *": {
            marginTop: 0
          },

          // Images
          img: {
            borderRadius: theme("borderRadius.lg")
          },

          // Inline elements
          a: {
            color: "var(--tw-prose-links)",
            // fontWeight: theme("fontWeight.medium"),
            textDecoration: "none"
            // transitionProperty: "color",
            // transitionDuration: theme("transitionDuration.150"),
            // transitionTimingFunction: theme("transitionTimingFunction.in-out"),
          },
          // "a:hover": {
          //   textDecoration: "underline",
          //   color: "var(--tw-prose-links-hover)",
          //   textDecorationColor: "var(--tw-prose-underline-hover)",
          // },
          "a.heading-link": {
            color: "transparent"
          },
          "a.heading-link:hover": {
            color: "var(--tw-prose-links-hover)"
          },
          strong: {
            color: "var(--tw-prose-bold)",
            fontWeight: theme("fontWeight.semibold")
          },
          code: {
            display: "inline-block",
            color: "var(--tw-prose-code)",
            fontSize: theme("fontSize.sm")[0],
            letterSpacing: "-0.5px",
            fontWeight: theme("fontWeight.normal"),
            backgroundColor: "var(--tw-prose-code-bg)",
            borderRadius: theme("borderRadius.lg"),
            paddingLeft: theme("spacing.1"),
            paddingRight: theme("spacing.1")
          },
          "a code": {
            color: "inherit"
          },
          ":is(h2, h3) code": {
            fontWeight: theme("fontWeight.bold")
          },

          // Quotes
          blockquote: {
            // color: theme("colors.radix.slate12"),
            fontSize: theme("fontSize.sm")[0],
            fontWeight: theme("fontWeight.medium"),
            paddingLeft: theme("spacing.6"),
            borderLeftWidth: theme("borderWidth.2"),
            borderLeftColor: "var(--tw-prose-quote-borders)"
          },

          // Figures
          figcaption: {
            color: "var(--tw-prose-captions)",
            fontSize: theme("fontSize.sm")[0],
            lineHeight: theme("lineHeight.6"),
            marginTop: theme("spacing.3")
          },
          "figcaption > p": {
            margin: 0
          },

          // Lists
          ol: {
            listStyleType: "decimal",
            paddingLeft: theme("spacing.6")
          },
          ul: {
            listStyleType: "none"
          },
          li: {
            marginTop: theme("spacing.3"),
            marginBottom: theme("spacing.3")
          },
          "ul > li::before": {
            content: '""',
            width: "0.75em",
            height: "0.125em",
            position: "absolute",
            top: "calc(0.875em - 0.0625em)",
            left: 0,
            borderRadius: "999px",
            backgroundColor: "var(--slate6)"
          },
          "ul > li": {
            position: "relative",
            paddingLeft: theme("spacing.6")
          },
          "ol > li::marker": {
            color: "var(--tw-prose-counters)"
          },
          "li :is(ol, ul)": {
            marginTop: theme("spacing.2"),
            marginBottom: theme("spacing.2")
          },
          "li :is(li, p)": {
            marginTop: theme("spacing.2"),
            marginBottom: theme("spacing.2")
          },

          // Code blocks
          pre: {
            color: "var(--tw-prose-pre-code)",
            fontSize: theme("fontSize.sm")[0],
            fontWeight: theme("fontWeight.medium"),
            backgroundColor: "var(--tw-prose-pre-bg)",
            borderRadius: theme("borderRadius.lg"),
            padding: theme("spacing.4"),
            overflowX: "auto",
            border: "1px solid",
            borderColor: "var(--tw-prose-pre-border)"
          },
          "pre code": {
            display: "inline",
            color: "inherit",
            fontSize: "inherit",
            fontWeight: "inherit",
            backgroundColor: "transparent",
            borderRadius: 0,
            padding: 0
          },

          // Horizontal rules
          hr: {
            marginTop: theme("spacing.16"),
            marginBottom: theme("spacing.16"),
            borderTopWidth: "1px",
            borderColor: "var(--tw-prose-hr)",
            "@screen lg": {
              marginLeft: `calc(${theme("spacing.12")} * -1)`,
              marginRight: `calc(${theme("spacing.12")} * -1)`
            }
          },

          // Tables
          table: {
            width: "100%",
            tableLayout: "auto",
            textAlign: "left",
            fontSize: theme("fontSize.sm")[0]
          },
          thead: {
            borderBottomWidth: "1px",
            borderBottomColor: "var(--tw-prose-th-borders)"
          },
          "thead th": {
            color: "var(--tw-prose-headings)",
            fontWeight: theme("fontWeight.semibold"),
            verticalAlign: "bottom",
            paddingBottom: theme("spacing.2")
          },
          "thead th:not(:first-child)": {
            paddingLeft: theme("spacing.2")
          },
          "thead th:not(:last-child)": {
            paddingRight: theme("spacing.2")
          },
          "tbody tr": {
            borderBottomWidth: "1px",
            borderBottomColor: "var(--tw-prose-td-borders)"
          },
          "tbody tr:last-child": {
            borderBottomWidth: 0
          },
          "tbody td": {
            verticalAlign: "baseline"
          },
          tfoot: {
            borderTopWidth: "1px",
            borderTopColor: "var(--tw-prose-th-borders)"
          },
          "tfoot td": {
            verticalAlign: "top"
          },
          ":is(tbody, tfoot) td": {
            paddingTop: theme("spacing.2"),
            paddingBottom: theme("spacing.2")
          },
          ":is(tbody, tfoot) td:not(:first-child)": {
            paddingLeft: theme("spacing.2")
          },
          ":is(tbody, tfoot) td:not(:last-child)": {
            paddingRight: theme("spacing.2")
          }
        }
      }
    }),
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans]
      }
    }
  }
}
