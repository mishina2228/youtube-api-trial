require 'test_helper'
require 'generators/devise/devise_generator'

class DeviseGeneratorTest < Rails::Generators::TestCase
  tests DeviseGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
