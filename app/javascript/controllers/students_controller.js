import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["absentStudentDiv", "searchResults"]

  connect() {
    console.log("absent student div", this.absentStudentDivTarget)
    console.log("SearchResultDiv", this.searchResultsTarget)

  }

  search = (e) => {
    let actionPath = e.target.getAttribute("data-searchpath");
    actionPath = `${actionPath}&student_name=${e.target.value}`
    console.log(e.target.value)
    const options = {
      method: 'GET'
    };
    fetch(actionPath, options)
      .then(response => {
        if (response.status == 500) {
          throw new Error('There was an internal server Error')
        }
        return response.json();
      })
      .then(data => {
        this.renderSearchResults(data)
      })
      .catch(error => {
        console.log("error", error)
      });
  }

  remove = (e) => {
    const removeStudentId = e.target.getAttribute("data-addedstudentid")
    const addStudentDiv = document.getElementById(removeStudentId)
    addStudentDiv.remove()
  }

  template = (studentId, fullName) => {
    return `
    <div class="added-student d-flex justify-content-between px-2" id="added_student_${studentId}" data-studentid=${studentId}>
      <p class="absent-student-name">🧨 ${fullName}</p>
      <p class="remove-from-list-btn" data-action="click->students#remove" 
           data-addedstudentid="added_student_${studentId}">Remove</p>
      <input autocomplete="off" type="hidden" name="progress[absent_students][][id]" 
      value=${studentId}">
      <input autocomplete="off" type="hidden" name="progress[absent_students][][full_name]" 
      value="${fullName}">
    </div>
    `
  }

  addToForm = (e) => {
    // Query all HTML elements with the class 'added-student' and convert the NodeList to an array
    const addedStudents = Array.from(document.querySelectorAll('.added-student'));
    // Use the map method to extract the value of the data-userid attribute for each element
    const studentIds = addedStudents.map(student => student.getAttribute('data-studentid'));

    const tempDiv = document.createElement('div');
    const fullName = e.target.textContent
    const studentId = e.target.getAttribute("data-studentid")
    if (!studentIds.includes(studentId)) {
      tempDiv.innerHTML = this.template(studentId, fullName)
      // Finding the first element node while avoiding empty spaces
      var generatedElement;
      for (var i = 0; i < tempDiv.childNodes.length; i++) {
        if (tempDiv.childNodes[i].nodeType === 1) { // 1 represents an element node
          generatedElement = tempDiv.childNodes[i];
          break;
        }
      }

      this.absentStudentDivTarget.appendChild(generatedElement)
      e.target.classList.add("dropdown-selection-anim")
      setTimeout(() => {
        e.target.classList.remove("dropdown-selection-anim")
      }, 1000);
    }
  }

  renderSearchResults = (users) => {
    this.searchResultsTarget.innerHTML = ""
    users.forEach(user => {
      const pTag = document.createElement('p');
      pTag.setAttribute("data-studentid", user.id);
      pTag.setAttribute("data-action", "click->students#addToForm");
      pTag.classList.add("search-result-item")

      pTag.textContent = user.full_name;
      this.searchResultsTarget.appendChild(pTag);
      console.log("search result target", this.searchResultsTarget)
    });
  }
}

