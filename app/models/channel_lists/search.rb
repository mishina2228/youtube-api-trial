class ChannelLists::Search < ChannelList
  attr_accessor :query

  # @param response [ListSubscriptionResponse]
  # @param query String
  def initialize(response, query)
    super(response)
    self.query = query
    self.channels = response.items.map do |subscription|
      channel_id = subscription.snippet.channel_id
      c = Channel.find_or_initialize_by(channel_id: channel_id)
      c.thumbnail_url = subscription.snippet.thumbnails.default.url
      c.title = subscription.snippet.title
      c.description = subscription.snippet.description
      c
    end
  end

  def self.search(query, token: nil, max_results: Consts::Youtube::LIST_MAX_RESULTS)
    ss = SystemSetting.first
    raise I18n.t('text.system_setting.missing') unless ss

    ss.youtube_service.search_channel(query, token: token, max_results: max_results)
  end
end
