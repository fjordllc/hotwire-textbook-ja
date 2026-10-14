import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = { counts: Array }
  connect() {
    if (document.documentElement.hasAttribute("data-turbo-preview")) return
    this.chart = new Chart(this.element, {
      type: "bar",
      data: { labels: ["todo", "in_progress", "done"], datasets: [{ label: "タスク数", data: this.countsValue }] },
      options: { animation: false, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
    })
  }
  teardown() { this.chart?.destroy(); this.chart = null }
  disconnect() { this.teardown() }
}
