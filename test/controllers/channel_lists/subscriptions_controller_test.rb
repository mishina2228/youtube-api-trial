# frozen_string_literal: true

require 'test_helper'

module ChannelLists
  class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
    test 'should get index as html' do
      assert system_setting.update(auth_method: :oauth2)
      assert system_setting.oauth2?
      sign_in admin

      get channel_lists_subscriptions_url
      assert_response :success
    end

    test 'should not get index if logged in as an user' do
      sign_in user

      get channel_lists_subscriptions_url
      assert_response :not_found
    end

    test 'should not get index unless logged in' do
      get channel_lists_subscriptions_url
      assert_response :not_found
    end

    test 'should get index via ajax as js' do
      assert system_setting.update(auth_method: :oauth2)
      sign_in admin

      get channel_lists_subscriptions_url, xhr: true
      assert_response :success
    end

    test 'should not get index via ajax as js if logged in as an user' do
      sign_in user

      get channel_lists_subscriptions_url, xhr: true
      assert_response :not_found
    end

    test 'should not get index via ajax as js unless logged in' do
      get channel_lists_subscriptions_url, xhr: true
      assert_response :not_found
    end
  end
end
