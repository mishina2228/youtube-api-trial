require 'google/apis/youtube_v3'

class Youtube::Service
  attr_accessor :api_key

  def initialize(api_key = nil)
    self.api_key = api_key
  end

  def service
    return @service if @service.present?

    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.key = api_key
    @service
  end

  def statistics(channel_id)
    status, res, error_message = get_channel(:statistics, channel_id)
    statics = res.items.first.try(:statistics)
    Youtube::ServiceResponse.new(status, statics, error_message)
  end

  def snippet(channel_id)
    status, res, error_message = get_channel(:snippet, channel_id)
    snippet = res.items.first.try(:snippet)
    Youtube::ServiceResponse.new(status, snippet, error_message)
  end

  def get_channel(part, channel_id)
    status = nil
    response = nil
    error_message = nil
    begin
      response = service.list_channels(part, id: channel_id)
      status = response.page_info.total_results.zero? ? Statuses::BLANK : Statuses::OK
    rescue Google::Apis::ClientError => e
      response = JSON.parse(e.body).with_indifferent_access
      status = error_status(response[:error][:errors][0][:reason])
      error_message = e.message
    end
    [status, response, error_message]
  end

  def error_status(error_reason)
    case error_reason
    when 'dailyLimitExceededUnreg'
      Statuses::UNREGISTERED
    when 'keyInvalid'
      Statuses::KEY_INVALID
    when 'unknownPart'
      Statuses::UNKNOWN_PART
    end
  end
end
