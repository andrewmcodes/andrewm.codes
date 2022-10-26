import "../frontend/styles/index.css"

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  layout: "centered",
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/
    }
  },
  backgrounds: {
    default: "dark",
    values: [
      {
        name: "dark",
        value: "#151718"
      },
      {
        name: "light",
        value: "#FBFCFD"
      }
    ]
  }
}
