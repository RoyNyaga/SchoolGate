import { Controller } from "@hotwired/stimulus"
import Cropper from 'cropperjs'
export default class extends Controller {
  static targets = ["source", "photoForm"];

  connect() {
    console.log("this is source target", this.sourceTarget)
  }

  previewPhoto = (e) => {
    const saveBtn = document.querySelector("#save-photo-btn");
    let reader, file;
    const files = e.target.files;
    var done = function (url) {
      this.sourceTarget.src = url; // preview selected image
    }.bind(this);

    if (files && files.length > 0) {
      file = files[0];

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

    saveBtn.classList.remove("d-none") // Display the save button
  }

  savePhoto = () => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
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
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          console.log("this is the response", response)
          return response.json(); // Parse response body as JSON
        })
        .then(data => {
          // Handle response data
          console.log('Response:', data);
        })
        .catch(error => {
          // Handle errors
          console.error('There was a problem with the fetch operation:', error);
        });
    })
  }
}
