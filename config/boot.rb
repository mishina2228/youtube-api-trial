ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# bootsnap fails at Raspberry Pi 3B
# https://romkey.com/2018/05/14/fixing-rails-5-2-bus-error-on-armv7-raspberry-pi/
unless File.exist?('/proc/cpuinfo') && File.read('/proc/cpuinfo').include?('ARMv7')
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end
