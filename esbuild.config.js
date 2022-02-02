const build = require("./config/esbuild.defaults.js")
const { watch } = require("chokidar")

const MODE = process.env["BRIDGETOWN_ENV"] || "production"
const outputFolder = "build"
const esbuildOptions = {}

build(outputFolder, esbuildOptions)

if (MODE === "development") {
  const watcher = watch(["./src/**/*.*{html,md,erb,rb}", "./frontend/javascript/*.js*", "./frontend/styles/*.*css*"])

  watcher
    .on("ready", () => {
      console.log("esbuild: initial development build")
    })
    .on("change", path => {
      console.log(`esbuild: file ${path} has been changed`)
      build(outputFolder, esbuildOptions)
    })
    .on("raw", (event, path, details) => {
      console.log("Raw event info:", event, path, details)
    })
  // watcher.close()
}
