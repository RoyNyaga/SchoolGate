import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fees"
export default class extends Controller {
  addFeeInput() {
    const lastInput = document.querySelector('#competences-inputs input:last-child');
  
    // Create a new element from the last input
    const newInput = lastInput.cloneNode(true);
    newInput.value = ""; // reseting the value
  
    // Prepend the new element back to the "fee-installments-inputs"
    const feeInstallmentsInputs = document.getElementById('competences-inputs');
    feeInstallmentsInputs.append(newInput);
  }

}
