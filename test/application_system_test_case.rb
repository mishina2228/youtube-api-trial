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
    options = Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless disable-dev-shm-usage no-sandbox window-size=1440,990]
    )
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  driven_by(:headless_chrome)

  Capybara.default_max_wait_time = 5
  Capybara.default_retry_interval = 0.25
  I18n.default_locale = :en # for the system that cannot display Japanese (e.g. GitHub Actions)

  # Generate csrf token to make the JS code work
  setup do
    ActionController::Base.allow_forgery_protection = true
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
    # It's too flaky
    # next unless passed?
    #
    # error_messages = filtered_javascript_errors
    # raise "Error with JavaScript: #{error_messages.join}" if error_messages.present?
  end

  def visit(*)
    super
    wait_for_turbo_frame
  end
end
