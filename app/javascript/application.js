/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'bootstrap'

import '../packs/src/channel'
import '../packs/src/channel_list'
import '../packs/src/channel_tag'
import '../packs/src/datepicker_loader'
import '../packs/src/fontawesome'
import '../packs/src/system_setting'
import '../packs/src/theme_changer'

import './application.scss'

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'

Rails.start()
Turbolinks.start()
global.$ = require('jquery')
global.toastr = require('toastr')

require.context('../packs/images', true)
