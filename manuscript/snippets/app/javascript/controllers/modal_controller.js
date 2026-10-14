import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.showModal()
  }

  close() { this.element.close() }
  cleanup() { this.element.remove() }

  disconnect() {
    // Validation may replace the dialog. Do not steal focus from its replacement.
    if (!document.querySelector("dialog[open]")) {
      document.getElementById("new_task_modal_link")?.focus()
    }
  }
}
