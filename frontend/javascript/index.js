import Alpine from "alpinejs"
import "index.css"

// Import all JavaScript & CSS files from src/_components
import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}"
window.Alpine = Alpine

Alpine.start()

console.info("Bridgetown is loaded!")
