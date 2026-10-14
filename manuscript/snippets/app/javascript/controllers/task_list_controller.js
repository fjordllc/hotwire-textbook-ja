import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame", "notice", "location"]

  changed() {
    if (!this.element.isConnected) return
    if (document.querySelector("[data-editing], dialog[open]") || this.element.dataset.mode !== "pages") {
      this.noticeTarget.hidden = false
    } else {
      this.refresh()
    }
  }

  loaded(event) {
    if (event.target !== this.frameTarget || !this.pending) return
    this.pending = false
    this.changed()
  }

  refresh() {
    if (this.frameTarget.hasAttribute("busy")) {
      this.pending = true
      this.noticeTarget.hidden = false
      return
    }
    this.noticeTarget.hidden = true
    // フレームに表示中の条件を使う。遷移中の window.location には依存しない。
    const url = new URL(this.locationTarget.dataset.url, window.location.origin)
    if (this.element.dataset.mode !== "pages") url.searchParams.delete("page")
    if (this.frameTarget.src === url.href) this.frameTarget.reload()
    else this.frameTarget.src = url.href
  }
}
