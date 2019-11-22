class ChannelLists::Subscription < ChannelList
  # @param response [ListSubscriptionResponse]
  def initialize(response)
    super
    self.channels = response.items.map do |subscription|
      channel_id = subscription.snippet.resource_id.channel_id
      c = Channel.find_or_initialize_by(channel_id: channel_id)
      c.thumbnail_url = subscription.snippet.thumbnails.default.url
      c.title = subscription.snippet.title
      c.description = subscription.snippet.description
      c
    end
  end

  def self.subscriptions(token: nil, max_results: Consts::Youtube::LIST_MAX_RESULTS)
    ss = SystemSetting.first
    raise I18n.t('helpers.notice.oauth2_required') unless ss&.oauth2?

    ss.youtube_service.subscriptions(token: token, max_results: max_results)
  end
end
