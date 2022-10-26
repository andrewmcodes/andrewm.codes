import { addons } from "@storybook/addons"
import { create } from "@storybook/theming"

const theme = create({
  base: "dark",
  appBg: "#1A1D1E"
})

addons.setConfig({
  theme
})
