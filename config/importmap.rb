# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@fortawesome/fontawesome-svg-core", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@6.7.2/index.mjs"
pin "@fortawesome/free-solid-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@6.7.2/index.mjs"
pin "@yaireo/tagify", to: "https://ga.jspm.io/npm:@yaireo/tagify@4.33.1/dist/tagify.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.6/dist/js/bootstrap.esm.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/flatpickr.js"
pin "flatpickr/dist/l10n/ja", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/l10n/ja.js"
pin "i18n-js", to: "https://ga.jspm.io/npm:i18n-js@3.9.2/app/assets/javascripts/i18n.js"
pin "izitoast", to: "https://ga.jspm.io/npm:izitoast@1.4.0/dist/js/iziToast.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/dist/esm/index.js"
pin "js-cookie", to: "https://ga.jspm.io/npm:js-cookie@3.0.5/dist/js.cookie.mjs"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin_all_from "app/javascript/i18n-js", under: "i18n-js"
pin_all_from "app/javascript/lib", under: "lib"
pin_all_from "app/javascript/controllers", under: "controllers"
