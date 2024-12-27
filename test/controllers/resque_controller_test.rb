# frozen_string_literal: true

require 'test_helper'

class ResqueControllerTest < ActionDispatch::IntegrationTest
  setup do
    # For HostAuthorization in Sinatra 4.1
    # https://github.com/sinatra/sinatra/pull/2053
    host! 'localhost'
  end

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
