require 'test_helper'

class ChannelLists::SubscriptionTest < ActiveSupport::TestCase
  def test_initialize
    service = Mishina::Youtube::Mock::Service.new
    response = service.subscriptions(token: 'TEST_TOKEN', max_results: 10)
    search = ChannelLists::Subscription.new(response)
    assert search.channels.is_a?(Array)
    assert(search.channels.all? {|c| c.is_a?(Channel)})
  end

  def test_subscriptions
    assert ss = SystemSetting.first
    assert ss.update(auth_method: :oauth2)
    assert ss.oauth2?
    ret = ChannelLists::Subscription.subscriptions(token: 'TEST_TOKEN', max_results: 10)
    assert ret.is_a?(Google::Apis::YoutubeV3::ListSubscriptionResponse)
  end

  def test_subscriptions_raise
    assert ss = SystemSetting.first
    assert ss.update(auth_method: :api_key)
    assert_raise do
      ChannelLists::Subscription.subscriptions
    end

    SystemSetting.destroy_all
    assert_raise do
      ChannelLists::Subscription.subscriptions
    end
  end
end
