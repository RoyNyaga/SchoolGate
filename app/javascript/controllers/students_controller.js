import { Controller } from "@hotwired/stimulus"
import Cropper from 'cropperjs'
export default class extends Controller {
  connect() {
    this.photoSaveRequest()
  }

  previewPhoto(e) {
    const previewImage = document.querySelector("#preview-image");
    let reader, file;
    const files = e.target.files;
    var done = function (url) {
      previewImage.src = url;
    };

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

    this.cropper = new Cropper(previewImage, {
      aspectRatio: 1,
      viewMode: 3,
      preview: '.preview',
      responsive: true,
    });

    console.log("called first level")

    document.querySelector("#save-photo-btn").addEventListener("click", () => {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      const canvas = this.cropper.getCroppedCanvas({
        width: 600,
        height: 600,
      });


      canvas.toBlob((blob) => {
        const formData = new FormData();

        // Pass the image file name as the third parameter if necessary.
        // formData.append('student', blob);
        formData.append('student[photo]', blob);

        console.log("this is blob", blob)
        console.log("this is form Data", formData)

        const options = {
          method: 'PUT',
          headers: {
            //'Content-Type': "multipart/form-data", // Specify content type as JSON
            'X-CSRF-Token': csrfToken,
          },
          body: formData
        };

        fetch("/students/44/update_photo", options)
          .then(response => {
            if (!response.ok) {
              throw new Error('Network response was not ok');
            }
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


    })
  }

  photoSaveRequest(croppedData) {
    console.log("has been called")
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const actionPath = document.querySelector("#student-form").action;

    console.log("this is the data to be posted", croppedData)
    const options = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json', // Specify content type as JSON
        'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify({ student: { photo: croppedData } })
    };

    // fetch(actionPath, options)
    //   .then(response => {
    //     if (!response.ok) {
    //       throw new Error('Network response was not ok');
    //     }
    //     return response.json(); // Parse response body as JSON
    //   })
    //   .then(data => {
    //     // Handle response data
    //     console.log('Response:', data);
    //   })
    //   .catch(error => {
    //     // Handle errors
    //     console.error('There was a problem with the fetch operation:', error);
    //   });
  }
}
