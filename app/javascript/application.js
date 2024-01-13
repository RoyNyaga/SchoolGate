// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

import "popper"
import "bootstrap"

document.addEventListener('turbo:load', function () {
  const leftSideBar = document.querySelector(".sidebar")
  if (leftSideBar) {
    console.log("one")
    const sideBarWidth = leftSideBar.clientWidth;
    const bodyWidth = document.body.clientWidth;
    const mainContentDiv = document.querySelector("#main-content-div")
    console.log(mainContentDiv)
    console.log("body width", bodyWidth)
    console.log("sidebar with: ", sideBarWidth)
    console.log(bodyWidth - sideBarWidth)
    mainContentDiv.style.width = `${bodyWidth - sideBarWidth}px`
  }
});



