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
    status, res, error = get_channel(:statistics, channel_id)
    statics = res.items.first.try(:statistics) if error.blank?
    Youtube::ServiceResponse.new(status, statics, error)
  end

  def snippet(channel_id)
    status, res, error = get_channel(:snippet, channel_id)
    snippet = res.items.first.try(:snippet) if error.blank?
    Youtube::ServiceResponse.new(status, snippet, error)
  end

  def get_channel(part, channel_id)
    status = nil
    response = nil
    error = nil
    begin
      response = service.list_channels(part, id: channel_id)
      status = response.page_info.total_results.zero? ? Statuses::BLANK : Statuses::OK
    rescue Google::Apis::ClientError => e
      status = Statuses::ERROR
      error = e
    end
    [status, response, error]
  end
end
