require 'simplecov'
SimpleCov.start 'rails'
if ENV['CI']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    Dir.glob(Rails.root.join('test/support/*.rb')).sort.each do |filename|
      require filename
      include File.basename(filename).split('.').first.camelize.constantize if filename.end_with?('_support.rb')
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end

module ActionController
  class TestCase
    include Devise::Test::ControllerHelpers
  end
end
