import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  select(event) { this.activate(this.tabTargets.indexOf(event.currentTarget)) }
  navigate(event) {
    const index = this.tabTargets.indexOf(event.target)
    let next
    if (event.key === "ArrowRight") next = (index + 1) % this.tabTargets.length
    else if (event.key === "ArrowLeft") next = (index - 1 + this.tabTargets.length) % this.tabTargets.length
    else if (event.key === "Home") next = 0
    else if (event.key === "End") next = this.tabTargets.length - 1
    else return
    event.preventDefault()
    this.activate(next)
    this.tabTargets[next].focus()
  }
  activate(index) {
    this.tabTargets.forEach((tab, i) => {
      tab.setAttribute("aria-selected", String(i === index))
      tab.tabIndex = i === index ? 0 : -1
      this.panelTargets[i].hidden = i !== index
    })
  }
}
