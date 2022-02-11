// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import 'bootstrap'

import 'controllers/channel'
import 'controllers/channel_list'
import 'controllers/channel_tag'
import 'controllers/datepicker_loader'
import 'controllers/fontawesome'
import 'controllers/system_setting'
import 'controllers/theme_changer'

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import $ from 'jquery'

Rails.start()
Turbolinks.start()
window.$ = $
