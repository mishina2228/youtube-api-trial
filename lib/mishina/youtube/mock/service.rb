require 'google/apis/youtube_v3'

class Mishina::Youtube::Mock::Service
  attr_accessor :service

  def initialize(_options = {})
    self
  end

  def statistics(channel_id)
    case channel_id
    when /error/
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::ERROR,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    when /blank/
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::BLANK,
        nil,
        Mishina::Youtube::NoChannelError.new(channel_id)
      )
    else
      Mishina::Youtube::ServiceResponse.new(
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
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::ERROR,
        nil,
        Google::Apis::ClientError.new('Invalid request')
      )
    when /blank/
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::BLANK,
        nil,
        Mishina::Youtube::NoChannelError.new(channel_id)
      )
    else
      Mishina::Youtube::ServiceResponse.new(
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

  def subscriptions(_token:, max_results:)
    snippet = Google::Apis::YoutubeV3::Subscription.new(
      channel_id: 'dummy_channel_id',
      title: 'dummy channel',
      thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
        default: Google::Apis::YoutubeV3::Thumbnail.new(url: 'https://example.com/thumbnail/dummy')
      )
    )
    Google::Apis::YoutubeV3::ListSubscriptionResponse.new(
      channels: Array.new(max_results, snippet)
    )
  end
end
