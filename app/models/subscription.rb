class Subscription
  attr_accessor :channels, :next_page_token, :prev_page_token, :total_results

  # @param response [ListSubscriptionResponse]
  def initialize(response)
    self.next_page_token = response.next_page_token
    self.prev_page_token = response.prev_page_token
    self.total_results = response.page_info.total_results
    self.channels = response.items.map do |subscription|
      channel_id = subscription.snippet.resource_id.channel_id
      c = Channel.find_or_initialize_by(channel_id: channel_id)
      c.thumbnail_url = subscription.snippet.thumbnails.default.url
      c.title = subscription.snippet.title
      c
    end
  end
end
