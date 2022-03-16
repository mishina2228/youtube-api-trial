require 'test_helper'

module ChannelLists
  class SearchTest < ActiveSupport::TestCase
    test 'initialize' do
      service = Mishina::Youtube::Mock::Service.new
      response = service.search_channel('dummy_query', token: 'TEST_TOKEN', max_results: 10)
      search = ChannelLists::Search.new(response)
      assert_instance_of Array, search.channels
      assert(search.channels.all?(Channel))
    end

    test 'search' do
      assert SystemSetting.first
      ret = ChannelLists::Search.search('dummy_query', token: 'TEST_TOKEN', max_results: 10)
      assert_instance_of Google::Apis::YoutubeV3::SearchListsResponse, ret
    end

    test "calling search without any SystemSetting's records should raise error" do
      SystemSetting.destroy_all
      assert_raise do
        ChannelLists::Search.search('dummy_query')
      end
    end
  end
end
