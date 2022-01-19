const build = require("./config/esbuild.defaults.js")

// Update this if you need to configure a destination folder other than `output`
const outputFolder = "output"

const path = require("path")
const esbuildCopy = require("esbuild-plugin-copy").default
const esbuildOptions = {
  plugins: [
    esbuildCopy({
      assets: {
        from: [path.resolve(__dirname, "static/*")],
        to: [path.resolve(__dirname, "output")]
      },
      verbose: false
    })
  ]
}

build(outputFolder, esbuildOptions)
