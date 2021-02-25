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

const exposed = {}
if (location.search) {
  var a = document.createElement("a")
  a.href = location.href
  a.search = ""
  history.replaceState(null, null, a.href)
}

function tweet_(url) {
  open("https://twitter.com/intent/tweet?url=" + encodeURIComponent(url), "_blank")
}
function tweet(anchor) {
  tweet_(anchor.getAttribute("href"))
}
expose("tweet", tweet)

function share(anchor) {
  var url = anchor.getAttribute("href")
  event.preventDefault()
  if (navigator.share) {
    navigator.share({
      url: url,
    })
  } else if (navigator.clipboard) {
    navigator.clipboard.writeText(url)
    message("Article URL copied to clipboard.")
  } else {
    tweet_(url)
  }
}
expose("share", share)

function message(msg) {
  var dialog = document.getElementById("message")
  dialog.textContent = msg
  dialog.setAttribute("open", "")
  setTimeout(function () {
    dialog.removeAttribute("open")
  }, 3000)
}

function expose(name, fn) {
  exposed[name] = fn
}

addEventListener("click", (e) => {
  const handler = e.target.closest("[on-click]")
  if (!handler) {
    return
  }
  e.preventDefault()
  const name = handler.getAttribute("on-click")
  const fn = exposed[name]
  if (!fn) {
    throw new Error("Unknown handler" + name)
  }
  fn(handler)
})
