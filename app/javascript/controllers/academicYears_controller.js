import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="academic-years"
export default class extends Controller {
  connect() {
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }

  toggleActiveness = (e) => {
    const btnId = e.target.getAttribute("data-btnid")
    const submitBtn = document.getElementById(btnId)
    submitBtn.click()
  }
}
