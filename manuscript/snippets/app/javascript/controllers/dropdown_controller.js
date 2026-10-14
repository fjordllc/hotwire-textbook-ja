import { Controller } from "@hotwired/stimulus"

// 第26章: サーバー不要のドロップダウン
export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const willOpen = this.menuTarget.hidden
    this.menuTarget.hidden = !willOpen
    this.buttonTarget.setAttribute("aria-expanded", String(willOpen))
  }

  close(event) {
    if (event.key === "Escape" || !this.element.contains(event.target)) {
      this.menuTarget.hidden = true
      this.buttonTarget.setAttribute("aria-expanded", "false")
      if (event.key === "Escape") this.buttonTarget.focus()
    }
  }
}
