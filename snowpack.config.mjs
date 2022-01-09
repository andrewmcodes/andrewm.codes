// https://www.snowpack.dev/reference/configuration

const runBridgetown = [
  "@snowpack/plugin-run-script",
  {
    name: "bridgetown",
    cmd: "yarn build:bridgetown",
    watch: "yarn watch:bridgetown"
  }
]

/** @type {import("snowpack").SnowpackUserConfig } */
export default {
  mount: {
    ".bridgetown-build": { url: "/", static: true, resolve: true },
    static: { url: "/", static: true, resolve: false },
    frontend: "/_dist"
  },
  plugins: ["@snowpack/plugin-postcss", runBridgetown],
  devOptions: {
    tailwindConfig: "./tailwind.config.js",
    open: "none",
    hmrDelay: 1000
  },
  buildOptions: {
    clean: true,
    out: "build",
    sourcemap: true
  },
  optimize: {
    bundle: true,
    minify: true,
    target: "es2020",
    entrypoints: ["./frontend/javascript/index.js"]
  }
}
