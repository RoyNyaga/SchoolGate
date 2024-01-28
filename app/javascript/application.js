// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "popper"
import "bootstrap"
import "chartkick"
import "Chart.bundle"
import "@hotwired/turbo-rails"
import "controllers"

import Cropper from 'cropperjs'

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

  var image = document.getElementById('image');
  var cropper, reader, file;

  document.body.addEventListener('change', function (e) {
    if (e.target.classList.contains('image')) {

      var files = e.target.files;
      var done = function (url) {
        image.src = url;
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
    }
  });

  document.querySelector("#crop-one").addEventListener('click', function () {
    cropper = new Cropper(image, {
      aspectRatio: 1,
      viewMode: 3,
      preview: '.preview'
    });
  });

  document.querySelector("#crop-council").addEventListener('hidden.bs.modal', function () {
    cropper.destroy();
    cropper = null;
  });

  document.getElementById('crop-two').addEventListener('click', function () {
    const canvas = cropper.getCroppedCanvas({
      width: 160,
      height: 160,
    });

    canvas.toBlob(function (blob) {
      var url = URL.createObjectURL(blob);
      var reader = new FileReader();
      reader.readAsDataURL(blob);
      reader.onloadend = function () {
        var base64data = reader.result;
        //alert(base64data);

        // var xhr = new XMLHttpRequest();
        // xhr.open('POST', 'crop_image_upload.php', true);
        // xhr.setRequestHeader('Content-Type', 'application/json');
        // xhr.onreadystatechange = function () {
        //   if (xhr.readyState == 4 && xhr.status == 200) {
        //     alert('Success upload image');
        //   }
        // };
        // xhr.send(JSON.stringify({ image: base64data }));
      };
    });
  });


});



