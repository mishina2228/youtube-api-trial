require 'test_helper'

module ChannelLists
  class SearchControllerTest < ActionDispatch::IntegrationTest
    test 'should get index as html' do
      sign_in admin

      get channel_lists_search_index_url
      assert_response :success
    end

    test 'should not get index if logged in as an user' do
      sign_in user

      assert_raise ActionController::RoutingError do
        get channel_lists_search_index_url
      end
    end

    test 'should not get index unless logged in' do
      assert_raise ActionController::RoutingError do
        get channel_lists_search_index_url
      end
    end

    test 'should get index via ajax as js' do
      sign_in admin

      get channel_lists_search_index_url, xhr: true
      assert_response :success
    end

    test 'should not get index via ajax as js if logged in as an user' do
      sign_in user

      assert_raise ActionController::RoutingError do
        get channel_lists_search_index_url, xhr: true
      end
    end

    test 'should not get index via ajax as js unless logged in' do
      assert_raise ActionController::RoutingError do
        get channel_lists_search_index_url, xhr: true
      end
    end
  end
end
