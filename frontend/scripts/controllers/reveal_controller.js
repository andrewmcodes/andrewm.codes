import Reveal from "stimulus-reveal-controller"
import { useClickOutside } from 'stimulus-use'

export default class extends Reveal {
  connect() {
    super.connect()
    useClickOutside(this)
  }

  clickOutside(event) {
    event.preventDefault()

    if (this.item === undefined) {
      this.itemTargets[0].classList.add(this.class)
      this.itemTargets[1].classList.remove(this.class)
      this.itemTargets[2].classList.add(this.class)
    }
  }
}
