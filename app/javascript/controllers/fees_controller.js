import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fees"
export default class extends Controller {
  addFeeInput() {
    const lastInput = document.querySelector('#fee-installments-inputs input:last-child');
  
    // Create a new element from the last input
    const newInput = lastInput.cloneNode(true);
    newInput.value = ""; // reseting the value
  
    // Prepend the new element back to the "fee-installments-inputs"
    const feeInstallmentsInputs = document.getElementById('fee-installments-inputs');
    feeInstallmentsInputs.append(newInput);
  }

  calculateSum() {
    const sumDiv = document.querySelector("#sumDiv")
    // Get all input elements within the "fee-installments-inputs" div
    const inputs = document.querySelectorAll('#fee-installments-inputs input');

    // Calculate the sum of values
    const sum = Array.from(inputs).reduce((total, input) => {
      return total + parseFloat(input.value) || total;
    }, 0);

    sumDiv.textContent = `${sum} frs`
  }

  moreSearchOptions(e){
    const advancedSearchInputDiv = document.querySelector("#advanced-search-input-fields")
    const lessOptionBtn = document.querySelector("#less-option-search-btn")
    advancedSearchInputDiv.classList.remove("d-none")
    lessOptionBtn.remove("d-none")
    e.target.classList.add("d-none")
  }

  lessSearchOptions(){

  }
}
