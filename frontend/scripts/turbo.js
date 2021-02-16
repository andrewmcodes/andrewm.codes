import * as Turbo from "@hotwired/turbo"

Turbo.setProgressBarDelay(0)
Turbo.start()
document.addEventListener("turbolinks:before-cache", function () {
  console.log('caching')
})
