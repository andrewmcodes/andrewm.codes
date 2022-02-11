const build = require("./config/esbuild.defaults.js")
const { watch } = require("chokidar")

const MODE = process.env["BRIDGETOWN_ENV"] || "production"
const outputFolder = "build"
const esbuildOptions = {}

build(outputFolder, esbuildOptions)

// WARNING: DO NOT COPY THIS FILE IT DOESN'T WORK CORRECTLY
// if (MODE === "development") {
//   const watcher = watch(["./src/**/*.*{html,md,erb,rb}", "./frontend/javascript/*.js*", "./frontend/styles/*.*css*"])

//   watcher
//     .on("ready", () => {
//       console.log("esbuild: initial development build")
//     })
//     .on("change", path => {
//       console.log(`esbuild: file ${path} has been changed`)
//       build(outputFolder, esbuildOptions)
//     })
//     .on("raw", (event, path, details) => {
//       console.log("Raw event info:", event, path, details)
//     })
//   // watcher.close()
// }

//  const path = require("path")
//  const esbuildCopy = require('esbuild-plugin-copy').default
//  const esbuildOptions = {
//    plugins: [
//      esbuildCopy({
//        assets: {
//          from: [path.resolve(__dirname, 'node_modules/somepackage/files/*')],
//          to: [path.resolve(__dirname, 'output/_bridgetown/somepackage/files')],
//        },
//        verbose: false
//      }),
//    ]
//  }
