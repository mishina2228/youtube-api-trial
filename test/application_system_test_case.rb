# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  # Register a custom driver to suppress the following deprecation warning.
  #
  #   The :capabilities parameter for Selenium::WebDriver::Chrome::Driver is deprecated.
  #   Use :options argument with an instance of Selenium::WebDriver::Chrome::Driver instead.
  #
  # See more info: https://stackoverflow.com/a/70948645
  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-dev-shm-usage no-sandbox])
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  driven_by(:headless_chrome)

  # It's too flaky
  # teardown do
  #   next unless passed?
  #
  #   ignore_error_messages = [
  #     'Failed to load resource: the server responded with a status of 404 ()',
  #     'Failed to load resource: the server responded with a status of 422 (Unprocessable Content)'
  #   ]
  #   error_messages = javascript_errors.reject do |message|
  #     ignore_error_messages.any? {|ignore| message.include?(ignore)}
  #   end
  #   raise "Error with JavaScript: #{error_messages.join}" if error_messages.present?
  # end
end
