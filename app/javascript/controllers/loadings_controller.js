import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loadings"
export default class extends Controller {
  static targets = ["loadingText"];

  connect() {
    console.log("loading is connected")
    const url = this.loadingTextTarget.getAttribute("data-endpoint")
    this.checkProcessStatus(url)
  }

  checkProcessStatus = async (url) => {
    try {
      while (true) {
        const response = await fetch(url);
        const data = await response.json();
        this.loadingTextTarget.innerText = data.progress_state
        console.log(data.is_processing )
        console.log(data.progress_state)
        if (data.is_processing === false) {
          window.location.href = data.redirect_url;
          break; // Exit the loop if process has ended
        } else {
          console.log("Process still running. Checking again in 5 seconds...");
          await new Promise(resolve => setTimeout(resolve, 1000)); // Wait for 5 seconds before making the next request
        }
      }
    } catch (error) {
      console.error("Error occurred:", error);
    }
  }
}
