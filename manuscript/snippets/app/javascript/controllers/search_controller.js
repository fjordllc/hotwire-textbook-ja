import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }
  connect() { this.lastSubmitted = this.signature() }
  signature() { return new URLSearchParams(new FormData(this.element)).toString() }
  startComposition() { this.composing = true; clearTimeout(this.timeout) }
  endComposition() { this.composing = false; this.submit() }
  submit(event) {
    clearTimeout(this.timeout)
    if (this.composing || event?.isComposing) return
    this.timeout = setTimeout(() => {
      const signature = this.signature()
      // input の後の blur に伴う change で、同じ検索を再送しない。
      if (signature === this.lastSubmitted) return
      this.lastSubmitted = signature
      this.element.requestSubmit()
    }, this.delayValue)
  }
  disconnect() { clearTimeout(this.timeout) }
}
