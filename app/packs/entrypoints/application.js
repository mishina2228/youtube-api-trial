/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require('bootstrap-sass')
require('@fortawesome/fontawesome-free/js/all')

import '../src/channel'
import '../src/channel_list'
import '../src/system_setting'
import '../src/theme_changer'

import './application.scss'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
require.context('../images', true)

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
global.$ = require('jquery')
require('js-cookie')
global.toastr = require('toastr')
require('bootstrap-tagsinput')
