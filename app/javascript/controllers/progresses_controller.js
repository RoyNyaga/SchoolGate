import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progresses"
export default class extends Controller {
  connect() {
    console.log("it has been connected")
  }

  addTopicToForm = (e) => {
    const title = e.target.getAttribute("data-topic-title")
    const id = e.target.getAttribute("data-topic-id")
    const topicToBeAdded = this.generateTopicFormElement(title, id)
    console.log("topic to be added", topicToBeAdded)
    // Creating a temporary div to hold the generated HTML
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = topicToBeAdded;
    // Finding the first element node
    var generatedElement;
    for (var i = 0; i < tempDiv.childNodes.length; i++) {
      if (tempDiv.childNodes[i].nodeType === 1) { // 1 represents an element node
        generatedElement = tempDiv.childNodes[i];
        break;
      }
    }
    const parentDiv = document.querySelector(".added-topics-wrapper")
    console.log("parent div", parentDiv)
    parentDiv.appendChild(generatedElement);
  }

  generateTopicFormElement = (topicTitle, topicId) => {
    return `
    <div class="added-topic">
      <h6 class="added-topic-header">${topicTitle}</h6>
      <div class="added-topic-body">
        <input name="progress[topics][][id]" value=${topicId} autocomplete="off" type="hidden" id="progress_id">
        <div class="d-flex justify-content-around">
          <div>
            <label>In Progress</label>
            <input type="radio" name="progress[topics][][progress]" id="progress_topics__progress_in_progress" value="in_progress">
          </div>
          <div>
            <label>Completed</label>
            <input type="radio" name="progress[topics][][progress]" id="progress_topics__progress_completed" value="completed">
          </div>
          <span>Cancel</span>
        </div>
      </div>
    </div>
  `;
  }
}
