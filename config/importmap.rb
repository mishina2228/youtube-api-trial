# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@fortawesome/fontawesome-svg-core", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@1.3.0/index.es.js"
pin "@fortawesome/free-solid-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@6.0.0/index.es.js"
pin "@yaireo/tagify", to: "https://ga.jspm.io/npm:@yaireo/tagify@4.9.6/dist/tagify.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.9/dist/flatpickr.js"
pin "flatpickr/dist/l10n/ja", to: "https://ga.jspm.io/npm:flatpickr@4.6.9/dist/l10n/ja.js"
pin "i18n-js", to: "https://ga.jspm.io/npm:i18n-js@3.8.0/app/assets/javascripts/i18n.js"
pin "izitoast", to: "https://ga.jspm.io/npm:izitoast@1.4.0/dist/js/iziToast.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.2/dist/esm/index.js"
pin "js-cookie", to: "https://ga.jspm.io/npm:js-cookie@3.0.1/dist/js.cookie.mjs"
pin "turbolinks", to: "https://ga.jspm.io/npm:turbolinks@5.2.0/dist/turbolinks.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.2/lib/assets/compiled/rails-ujs.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin_all_from "app/javascript/i18n-js", under: "i18n-js"
pin_all_from "app/javascript/lib", under: "lib"
pin_all_from "app/javascript/controllers", under: "controllers"
