import 'alpine-turbo-drive-adapter'
import 'alpinejs';
import * as Turbo from "@hotwired/turbo";

Turbo.setProgressBarDelay(1)
// const env = document.querySelector("body").dataset.env

// // Check that service workers are supported
// if ("serviceWorker" in navigator && env === "production") {
//   // use the window load event to keep the page load performant
//   window.addEventListener("load", () => {
//     try {
//       navigator.serviceWorker.register("/sw.js")
//     } catch (error) {
//       console.error("Service worker registration failed: ", error)
//     }
//   })
// }
