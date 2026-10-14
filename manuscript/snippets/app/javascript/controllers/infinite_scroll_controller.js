import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["button"]
  initialize() {
    this.observer = new IntersectionObserver((entries) => {
      for (const entry of entries) {
        if (entry.isIntersecting && entry.target.isConnected) {
          // 同じリンクの自動送信は一度だけ。失敗時は手動で再試行できる。
          this.observer.unobserve(entry.target)
          entry.target.click()
        }
      }
    })
  }
  buttonTargetConnected(button) { this.observer.observe(button) }
  buttonTargetDisconnected(button) { this.observer.unobserve(button) }
  disconnect() { this.observer.disconnect() }
}
