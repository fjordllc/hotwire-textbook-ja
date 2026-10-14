import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  connect() {
    if (document.documentElement.hasAttribute("data-turbo-preview")) return
    this.picker = flatpickr(this.element, { dateFormat: "Y-m-d", allowInput: true })
  }
  teardown() { this.picker?.destroy(); this.picker = null }
  disconnect() { this.teardown() }
}
