# frozen_string_literal: true

require 'test_helper'

module ChannelLists
  class SubscriptionTest < ActiveSupport::TestCase
    test 'initialize' do
      service = Mishina::Youtube::Mock::Service.new
      response = service.subscriptions(token: 'TEST_TOKEN', max_results: 10)
      search = ChannelLists::Subscription.new(response)
      assert_instance_of Array, search.channels
      assert(search.channels.all?(Channel))
    end

    test 'subscriptions' do
      assert system_setting.update(auth_method: :oauth2)
      assert system_setting.oauth2?
      ret = ChannelLists::Subscription.subscriptions(token: 'TEST_TOKEN', max_results: 10)
      assert_instance_of Google::Apis::YoutubeV3::ListSubscriptionResponse, ret
    end

    test 'calling subscriptions when auth_method is api_key should raise error' do
      assert system_setting.update(auth_method: :api_key)
      assert_raise do
        ChannelLists::Subscription.subscriptions
      end
    end

    test "calling subscriptions without any SystemSetting's records should raise error" do
      SystemSetting.destroy_all
      assert_raise do
        ChannelLists::Subscription.subscriptions
      end
    end
  end
end
