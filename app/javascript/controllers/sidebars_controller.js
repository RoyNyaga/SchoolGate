import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebars"
export default class extends Controller {
  connect() {
    console.log("sidebars have been connected!!!!!!")
  }

  openDropdown = (e) => {
    let elementWithEventListener;

    if(e.target.getAttribute("data-expand-div-id")){
      elementWithEventListener = e.target
    }else{
      elementWithEventListener = e.target.parentElement
    }

    const expandedDivId = elementWithEventListener.getAttribute("data-expand-div-id")
    const expandedDiv = document.querySelector(`#${expandedDivId}`)
    expandedDiv.classList.toggle("d-none")
    const arrowUp = document.querySelector(`#${expandedDivId}_arrow_up`)
    elementWithEventListener.classList.toggle("d-none");
    arrowUp.classList.toggle("d-none")

    console.log("expanded div", expandedDiv)
  }

  closeDropdown = (e) => {
    let elementWithEventListener;

    if(e.target.getAttribute("data-expand-div-id")){
      elementWithEventListener = e.target
    }else{
      elementWithEventListener = e.target.parentElement
    }

    const expandedDivId = elementWithEventListener.getAttribute("data-expand-div-id")
    const expandedDiv = document.querySelector(`#${expandedDivId}`)
    expandedDiv.classList.toggle("d-none")
    const arrowDown = document.querySelector(`#${expandedDivId}_arrow_down`)

    elementWithEventListener.classList.toggle("d-none");
    arrowDown.classList.toggle("d-none")
    console.log("expanded div", expandedDiv)

  }
}
