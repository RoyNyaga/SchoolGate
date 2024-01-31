import { Controller } from "@hotwired/stimulus"
import Cropper from 'cropperjs'
export default class extends Controller {
  static targets = ["source", "photoForm", "profileImage", "clearPhotoBtn", "savePhotoBtn", "uploadInputField", "info"];

  connect() {
  }

  previewPhoto = (e) => {
    if (this.cropper && this.cropper.cropper) {
      this.clearPhoto()
    }

    let reader, file;
    const files = e.target.files;
    var done = function (url) {
      this.sourceTarget.src = url; // preview selected image
    }.bind(this);

    if (files && files.length > 0) {
      file = files[0];
      if (file.size > 2200000){
       this.updateInfo("text-warning", "We recommend photos less than 2.2mb for best experience")
      }

      if (URL) {
        done(URL.createObjectURL(file));
      } else if (FileReader) {
        reader = new FileReader();
        reader.onload = function (e) {
          done(reader.result);
        };
        reader.readAsDataURL(file);
      }
    }

    // trigger cropper to open the photo editor
    this.cropper = new Cropper(this.sourceTarget, {
      aspectRatio: 1,
      viewMode: 3,
      preview: '.preview',
      responsive: true,
    });

    this.savePhotoBtnTarget.classList.remove("d-none") // Display the save button
    this.clearPhotoBtnTarget.classList.remove("d-none")
  }

  savePhoto = () => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    console.log("this.profileImageTarget", this.profileImageTarget)
    // const action = document.querySelector("#student-photo-upload-form").action

    const canvas = this.cropper.getCroppedCanvas({
      width: 600,
      height: 600,
    });

    canvas.toBlob((blob) => {
      const formData = new FormData();
      formData.append('student[photo]', blob);
      const options = {
        method: 'PUT',
        headers: {
          //'Content-Type': "multipart/form-data", // Remove content type due to some params verification issues that it was coursing on saving the iamge
          'X-CSRF-Token': csrfToken,
        },
        body: formData
      };

      fetch(this.photoFormTarget.action, options)
        .then(response => {
          if (response.status == 500) {
            throw new Error('There was an internal server Error')
          }
          return response.json();
        })
        .then(data => {
          if (data.success) {
            this.closePhotoFormModal(data.modal_id)
            this.updateImage(data.image_url)
            this.flashMessage("success", data.message)
            this.clearPhoto(true)
          } else {
            const errorMessage = `Error!, ${data.message.join(",")}`
            this.flashMessage("error", errorMessage)
            this.closePhotoFormModal(data.modal_id)
          }
        })
        .catch(error => {
          this.flashMessage("error", error)
        });
    }, 'image/jpeg', 0.7) // compressing to 0.7 % and changing file type to jpeg
  }

  triggerClearPhoto = () => {
    this.clearPhoto(true)
  }

  clearPhoto = (with_input = false) => {
      this.cropper.destroy()
      this.sourceTarget.src = ""
      this.savePhotoBtnTarget.classList.add("d-none")
      this.clearPhotoBtnTarget.classList.add("d-none")
      with_input ? this.uploadInputFieldTarget.value = "" : null
      this.updateInfo("text-warning", "")
  }

  closePhotoFormModal = (modalId) => {
    const modal = document.querySelector(`#${modalId}`)
    const b_modal_instance = bootstrap.Modal.getInstance(modal)
    b_modal_instance.hide()
  }

  updateImage = (url) => {
    this.profileImageTarget.src = url
  }

  flashMessage = (type, message) => {
    const flashMessageParent = document.querySelector("#custom-flash")
    const messageClassName = `flash__message_${type}`
    const flashMessageChild = document.createElement("div")
    flashMessageChild.className = messageClassName
    flashMessageChild.innerText = message
    flashMessageParent.appendChild(flashMessageChild)
  }

  updateInfo = (type, message) => {
    this.infoTarget.className = type
    this.infoTarget.innerText = message
  }
}

