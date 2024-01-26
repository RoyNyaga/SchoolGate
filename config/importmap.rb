# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chartkick", to: "chartkick.js", preload: true
pin "Chart.bundle", to: "Chart.bundle.js", preload: true
pin "cropperjs", to: "https://ga.jspm.io/npm:cropperjs@1.6.1/dist/cropper.js", preload: true
