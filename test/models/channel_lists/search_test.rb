require 'test_helper'

class ChannelLists::SearchTest < ActiveSupport::TestCase
  test 'initialize' do
    service = Mishina::Youtube::Mock::Service.new
    response = service.search_channel('dummy_query', token: 'TEST_TOKEN', max_results: 10)
    search = ChannelLists::Search.new(response)
    assert search.channels.is_a?(Array)
    assert(search.channels.all?(Channel))
  end

  test 'search' do
    assert SystemSetting.first
    ret = ChannelLists::Search.search('dummy_query', token: 'TEST_TOKEN', max_results: 10)
    assert ret.is_a?(Google::Apis::YoutubeV3::SearchListsResponse)
  end

  test "calling search without any SystemSetting's records should raise error" do
    SystemSetting.destroy_all
    assert_raise do
      ChannelLists::Search.search('dummy_query')
    end
  end
end
