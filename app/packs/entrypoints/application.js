/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'bootstrap'

import '../src/channel'
import '../src/channel_list'
import '../src/system_setting'
import '../src/theme_changer'

import './application.scss'

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'

Rails.start()
Turbolinks.start()
global.$ = require('jquery')
global.toastr = require('toastr')
require('bootstrap-tagsinput')

require.context('../images', true)
