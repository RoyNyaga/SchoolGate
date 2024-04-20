import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="course-registration"
export default class extends Controller {
  static targets = ["addedCoursesWrapper", "searchResults"]

  connect() {
    console.log("Registration controller connected")
  }

  search = (e) => {
    let actionPath = e.target.getAttribute("data-searchpath");
    actionPath = `${actionPath}?query=${e.target.value}`
    console.log("this is action path", actionPath)
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
        console.log("this is data", data)
        this.renderSearchResults(data)
      })
      .catch(error => {
        console.log("error", error)
      });
  }

  template = (courseId, completeName, creditVal) => {
    return `
    <div class="added-course d-flex justify-content-between px-2" id="added_course_${courseId}" 
     data-courseid=${courseId}>
      <p class="added-course-fullname">🧨 ${completeName}</p>
      <p class="remove-from-list-btn" data-action="click->courseRegistration#remove" 
           data-addedcourseId="added_course_${courseId}">Remove</p>
      <input autocomplete="off" type="hidden" name="course_registration[courses][][id]" 
      value=${courseId}>
      <input autocomplete="off" type="hidden" name="course_registration[courses][][complete_name]" 
      value="${completeName}">
      <input autocomplete="off" type="hidden" name="course_registration[courses][][credit_val]" 
      value=${creditVal}>
    </div>
    `
  }

  addToForm = (e) => {
    // Query all HTML elements with the class 'added-course' and convert the NodeList to an array
    const addedCourses = Array.from(document.querySelectorAll('.added-course'));
    // Use the map method to extract the value of the data-userid attribute for each element
    const courseIds = addedCourses.map(student => student.getAttribute('data-courseid'));

    const tempDiv = document.createElement('div');
    const completeName = e.target.textContent
    const courseId = e.target.getAttribute("data-courseid")
    const courseCreditVal = e.target.getAttribute("data-course-creditvalue")
    if (!courseIds.includes(courseId)) {
      tempDiv.innerHTML = this.template(courseId, completeName, courseCreditVal)
      // Finding the first element node while avoiding empty spaces
      var generatedElement;
      for (var i = 0; i < tempDiv.childNodes.length; i++) {
        if (tempDiv.childNodes[i].nodeType === 1) { // 1 represents an element node
          generatedElement = tempDiv.childNodes[i];
          break;
        }
      }

      this.addedCoursesWrapperTarget.appendChild(generatedElement)
      e.target.classList.add("dropdown-selection-anim")
      setTimeout(() => {
        e.target.classList.remove("dropdown-selection-anim")
      }, 1000);
    }
  }

  remove = (e) => {
    const courseId = e.target.getAttribute("data-addedcourseId")
    const courseDiv = document.getElementById(courseId)
    courseDiv.remove()
  }

  renderSearchResults = (courses) => {
    this.searchResultsTarget.innerHTML = ""
    courses.forEach(course => {
      const pTag = document.createElement('p');
      pTag.setAttribute("data-courseid", course.id);
      pTag.setAttribute("data-course-creditvalue", course.credit_value)
      pTag.setAttribute("data-action", "click->courseRegistration#addToForm");
      pTag.classList.add("search-result-item")

      pTag.textContent = course.complete_name;
      this.searchResultsTarget.appendChild(pTag);
      console.log("search result target", this.searchResultsTarget)
    });
  }
}
