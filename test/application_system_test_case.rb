# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  driven_by :selenium, using: :headless_chrome do |options|
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--no-sandbox')
  end
end
