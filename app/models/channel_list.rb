class ChannelList
  attr_accessor :channels, :next_page_token, :prev_page_token, :total_results

  DEFAULT_PER = 10

  # @param response [ListSubscriptionResponse]
  def initialize(response)
    self.next_page_token = response.next_page_token
    self.prev_page_token = response.prev_page_token
    self.total_results = response.page_info.total_results
  end
end
