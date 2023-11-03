# frozen_string_literal: true

require 'test_helper'

class ResqueControllerTest < ActionDispatch::IntegrationTest
  test 'should get /resque' do
    sign_in admin

    get '/resque'
    assert_response :redirect
    uri = URI.parse(response.location)
    assert_equal '/resque/overview', uri.path
  end

  test 'should not get /resque if logged in as an user' do
    sign_in user

    get '/resque'
    assert_response :not_found
  end

  test 'should not get /resque unless logged in' do
    get '/resque'
    assert_response :not_found
  end
end
