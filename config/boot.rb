ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# bootsnap fails at Raspberry Pi 3B in particular Ruby versions.
# If you use Ruby version less than 2.6, comment out the line below.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
