const build = require("./config/esbuild.defaults.js")
const { watch } = require("chokidar")

const MODE = process.env["BRIDGETOWN_ENV"] || "production"
const outputFolder = "build"
const esbuildOptions = {}

if (MODE === "development") {
  const watcher = watch(["./src/**/*.*{html,md,erb,rb}", "./frontend/javascript/*.js*", "./frontend/styles/*.*css*"])
  watcher
    .on("ready", () => {
      console.log("esbuild: initial development build")
      build(outputFolder, esbuildOptions)
    })
    .on("change", path => {
      console.log(`esbuild: file ${path} has been changed`)
      build(outputFolder, esbuildOptions)
    })
} else {
  console.log("esbuild: production build")
  build(outputFolder, esbuildOptions)
}
