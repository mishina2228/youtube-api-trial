require 'test_helper'

class ChannelLists::SearchTest < ActiveSupport::TestCase
  def test_initialize
    service = Mishina::Youtube::Mock::Service.new
    response = service.search_channel('dummy_query', token: 'TEST_TOKEN', max_results: 10)
    search = ChannelLists::Search.new(response)
    assert search.channels.is_a?(Array)
    assert(search.channels.all? {|c| c.is_a?(Channel)})
  end

  def test_search
    assert SystemSetting.first
    ret = ChannelLists::Search.search('dummy_query', token: 'TEST_TOKEN', max_results: 10)
    assert ret.is_a?(Google::Apis::YoutubeV3::SearchListsResponse)
  end

  def test_search_raise
    SystemSetting.destroy_all
    assert_raise do
      ChannelLists::Search.search('dummy_query')
    end
  end
end
