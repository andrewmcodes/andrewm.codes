import * as Turbo from "@hotwired/turbo"
import "alpine-turbo-drive-adapter"
import Alpine from "alpinejs"
import ui from "@alpinejs/ui"
import focus from "@alpinejs/focus"
import "focus-visible"

import "index.css"

Alpine.store("darkMode", {
  init() {
    this.on = window.matchMedia("(prefers-color-scheme: dark)").matches
  },

  on: false,

  toggle() {
    console.log("toggle", this.on)
    this.on = !this.on
  }
})

// Alpine.magic("clipboard", () => subject => {
//   // <button @click="$clipboard('hello world')">Copy "Hello World"</button>
//   try {
//     navigator.clipboard.writeText(subject)
//   } catch (error) {
//     console.log("clipboard:", error)
//   }
// })

Alpine.magic("year", () => {
  // <span x-text="$year"></span>
  return new Date().getFullYear().toString()
})

// Register Alpine Plugins
Alpine.plugin(ui)
Alpine.plugin(focus)

// Start Alpine
window.Alpine = Alpine
Alpine.start()
