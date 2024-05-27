import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["referal"];

  connect() {
   console.log("mixins controller has been connected")
  }

  goBack = () => {
    window.history.back();
  }

  hideReferal = () => {
    this.referalTarget.classList.add("d-none")
  }

  showReferal = () => {
    this.referalTarget.classList.remove("d-none")
  }
}
