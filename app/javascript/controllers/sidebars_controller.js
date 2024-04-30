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
    const queryFooter = `#footer-navbar #${expandedDivId}`// for the footer sidebar
    const querySidebar = `#${expandedDivId}` // for the normal sidebar
    const screenWidth = window.screen.width;
    console.log("Screen width", screenWidth)

    const expandedDiv = screenWidth <= 768 ? document.querySelector(queryFooter) : document.querySelector(querySidebar)
    expandedDiv.classList.toggle("d-none")
    const arrowUp = screenWidth <= 768 ? document.querySelector(`#footer-navbar #${expandedDivId}_arrow_up`) : document.querySelector(`#${expandedDivId}_arrow_up`)
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
    const queryFooter = `#footer-navbar #${expandedDivId}`// for the footer sidebar
    const querySidebar = `#${expandedDivId}` // for the normal sidebar
    const screenWidth = window.screen.width;
    const expandedDiv = screenWidth <= 768 ? document.querySelector(queryFooter) : document.querySelector(querySidebar)
    expandedDiv.classList.toggle("d-none")
    const arrowDown = screenWidth <= 768 ? document.querySelector(`#footer-navbar #${expandedDivId}_arrow_down`) : document.querySelector(`#${expandedDivId}_arrow_down`)


    elementWithEventListener.classList.toggle("d-none");
    arrowDown.classList.toggle("d-none")
    console.log("expanded div", expandedDiv)

  }
}
