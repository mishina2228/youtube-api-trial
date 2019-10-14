class ChannelLists::Subscription < ChannelList
  def self.subscriptions(token: nil, max_results: 50)
    ss = SystemSetting.first
    raise I18n.t('helpers.notice.oauth2_required') unless ss&.oauth2?

    ss.youtube_service.subscriptions(token: token, max_results: max_results)
  end
end
