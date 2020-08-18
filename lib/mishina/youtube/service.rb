require 'google/apis/youtube_v3'

class Mishina::Youtube::Service
  attr_accessor :service

  def initialize(options = {})
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = options.delete(:api_key)
    service.authorization = options.delete(:credentials)
    self.service = service
  end

  def statistics(channel_id)
    status, res, error = get_channel('statistics', channel_id)
    statics = res.items.first.statistics if error.blank?
    Mishina::Youtube::ServiceResponse.new(status, statics, error)
  end

  def snippet(channel_id)
    status, res, error = get_channel('snippet', channel_id)
    snippet = res.items.first.snippet if error.blank?
    Mishina::Youtube::ServiceResponse.new(status, snippet, error)
  end

  # @return [Google::Apis::YoutubeV3::ListSubscriptionResponse]
  def subscriptions(token:, max_results:)
    service.list_subscriptions('snippet', mine: true, max_results: max_results, page_token: token)
  end

  # @return [Google::Apis::YoutubeV3::SearchListsResponse]
  def search_channel(query, max_results:, token:, safe_search: 'moderate')
    service.list_searches(
      'snippet',
      q: query, safe_search: safe_search, type: 'channel', max_results: max_results, page_token: token
    )
  end

  private

  def get_channel(part, channel_id)
    response = nil
    begin
      response = service.list_channels(part, id: channel_id)
      status, error = if response.items.blank?
                        [Consts::Statuses::BLANK, Mishina::Youtube::NoChannelError.new(channel_id)]
                      else
                        [Consts::Statuses::OK, nil]
                      end
    rescue Google::Apis::ClientError => e
      status = Consts::Statuses::ERROR
      error = e
    end
    [status, response, error]
  end
end
