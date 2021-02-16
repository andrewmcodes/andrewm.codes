import { Application } from "stimulus"
import * as Turbo from "@hotwired/turbo"
import Reveal from "./controllers/reveal_controller"

Turbo.setProgressBarDelay(1)
const application = Application.start()
application.register("reveal", Reveal)

window.addEventListener("turbo:before-cache", () => {
  document.querySelectorAll(".prose h1, .prose h2, .prose h3, .prose h4").forEach((headerEl) => {
    const linkEl = document.createElement("a")
    linkEl.setAttribute("href", "#" + headerEl.id)
    linkEl.innerText = " #"
    headerEl.appendChild(linkEl)
  })
})
