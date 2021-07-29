source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '>= 2.6', '< 3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 5.4'
gem 'puma_worker_killer'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# User Authorization
gem 'cancancan'
gem 'devise', '~> 4.8.0'
gem 'devise-i18n'

gem 'acts-as-taggable-on', '~> 8.1'
gem 'enum_help'
gem 'google-apis-youtube_v3', '~> 0.9.0'
gem 'i18n-js'
gem 'kaminari', '~> 1.2.1'
gem 'paranoia', '~> 2.4'

gem 'resque'
gem 'resque-scheduler'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'brakeman'
  gem 'bullet'
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console', '>= 3.3.0'

  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'codecov', require: false
  gem 'minitest-ci'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

group :itamae do
  gem 'god'
  gem 'itamae'
end
