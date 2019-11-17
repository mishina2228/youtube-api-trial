ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def user
    User.find_by!(admin: false)
  end

  def admin
    User.find_by!(admin: true)
  end

  def sample_exception
    exception = Mishina::Youtube::NoChannelError.new('test_channel_id')
    backtrace = [
      '..app/jobs/channel/build_statistics_job.rb:22:in `perform`',
      '..app/models/channel.rb:38:in `build_statistics!`'
    ]
    exception.set_backtrace(backtrace)
    exception
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
