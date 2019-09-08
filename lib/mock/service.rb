require 'google/apis/youtube_v3'

class Mock::Service
  attr_accessor :api_key

  def initialize(api_key = nil)
    self.api_key = api_key
  end

  def service
    self
  end

  def statistics(channel_id)
    case channel_id
    when /error/
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::ERROR,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    when /blank/
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::BLANK,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    else
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::OK,
        Google::Apis::YoutubeV3::ChannelStatistics.new(
          view_count: 5000,
          subscriber_count: 100_000,
          video_count: 50
        ),
        nil
      )
    end
  end

  def snippet(channel_id)
    case channel_id
    when /error/
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::ERROR,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    when /blank/
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::BLANK,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    else
      ::Youtube::ServiceResponse.new(
        Consts::Statuses::OK,
        Google::Apis::YoutubeV3::ChannelSnippet.new(
          title: 'dummy channel',
          description: 'dummy description',
          thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
            default: Google::Apis::YoutubeV3::Thumbnail.new(url: 'https://example.com/thumbnail/dummy')
          ),
          published_at: Time.current
        ),
        nil
      )
    end
  end
end
