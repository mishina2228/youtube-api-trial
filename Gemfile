# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '>= 3.2', '< 4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 6.6'
gem 'puma_worker_killer'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

gem 'dartsass-rails'
gem 'propshaft'

gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.13'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# User Authorization
gem 'cancancan'
gem 'devise'
gem 'devise-i18n'

gem 'acts-as-taggable-on', '~> 12.0'
gem 'enum_help'
gem 'google-apis-youtube_v3', '~> 0.56'
gem 'i18n-js'
# Workaround until a new version is released that includes support for https://github.com/kaminari/kaminari/issues/1055
gem 'kaminari', git: 'https://github.com/kaminari/kaminari', ref: 'c7a46f17b2bc1d842a3fe4d0132709bc27e02402'

gem 'resque'
gem 'resque-scheduler'

gem 'mail', '~> 2.8.1'

group :development do
  gem 'brakeman'
  gem 'bullet'
  gem 'erb_lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console', '>= 3.3.0'

  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 4.0', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'minitest-ci'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
end

group :itamae do
  gem 'itamae'
  gem 'net-scp', '>= 3.0.0'
  gem 'resurrected_god'
end
