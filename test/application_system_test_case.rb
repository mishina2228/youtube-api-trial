require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      'args' => %w(--headless --disable-gpu --no-sandbox)
    }
  )
  driven_by :selenium, using: :chrome, options: {desired_capabilities: caps}
end
