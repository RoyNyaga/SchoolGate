import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // this.element.textContent = "Hello World! stimulus has been triggered"
  }

  goBack = () => {
    window.history.back();
  }
}