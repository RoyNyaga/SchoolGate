import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progresses"
export default class extends Controller {
  connect() {
  }

  addTopicToForm = (e) => {
    const addedTopics = Array.from(document.querySelectorAll('.added-topic'));
    const topicIds = addedTopics.map(student => student.getAttribute('data-topicid'));
    const title = e.target.getAttribute("data-topic-title")
    const id = e.target.getAttribute("data-topic-id")
    const thumpUpAlertId = e.target.getAttribute("data-topic-thumpalertid")
    const thumpUpElement = document.getElementById(thumpUpAlertId)
    if (!topicIds.includes(id)) {
      const topicToBeAdded = this.generateTopicFormElement(title, id)
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

      parentDiv.appendChild(generatedElement);
      // trigger thump up alert
      thumpUpElement.classList.toggle('d-none');
      setTimeout(() => {
        thumpUpElement.classList.toggle('d-none');
      }, 1000);
    }

  }

  removeTopic = (e) => {
    const addedTopicId = e.target.getAttribute("data-topicelementid")
    const addedTopicDiv = document.getElementById(addedTopicId)
    addedTopicDiv.remove()
  }

  generateTopicFormElement = (topicTitle, topicId) => {
    return `
    <div class="added-topic" id="added_topic_${topicId}" data-topicid=${topicId}>
          <h6 class="added-topic-header">${topicTitle}</h6>
          <div class="added-topic-body">
            <input name="progress[topics][][id]" value=${topicId} autocomplete="off" type="hidden" id="progress_id">
            <div class="d-flex justify-content-around">
              <select class="progress-curriculum-select-input" name="progress[topics][][progress]" id="">
                <option value="3">completed</option>
                <option value="2">in_progress</option>
              </select>
              <span data-topicelementid="added_topic_${topicId}" data-action="click->progresses#removeTopic">Cancel</span>
            </div>
          </div>
        </div>
  `;
  }
}
