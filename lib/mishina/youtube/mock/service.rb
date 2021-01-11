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
    when /hidden_subscriber/
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::OK,
        Google::Apis::YoutubeV3::ChannelStatistics.new(
          hidden_subscriber_count: true,
          video_count: 50,
          view_count: 5000
        ),
        nil
      )
    else
      Mishina::Youtube::ServiceResponse.new(
        Consts::Statuses::OK,
        Google::Apis::YoutubeV3::ChannelStatistics.new(
          hidden_subscriber_count: false,
          subscriber_count: 100_000,
          video_count: 50,
          view_count: 5000
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

  # @return [Google::Apis::YoutubeV3::ListSubscriptionResponse]
  def subscriptions(token:, max_results:)
    subscription = Google::Apis::YoutubeV3::Subscription.new(
      snippet: Google::Apis::YoutubeV3::SubscriptionSnippet.new(
        resource_id: Google::Apis::YoutubeV3::ResourceId.new(
          channel_id: 'dummy_channel_id'
        ),
        title: 'dummy channel',
        description: 'dummy description',
        thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
          default: Google::Apis::YoutubeV3::Thumbnail.new(url: 'https://example.com/thumbnail/dummy')
        )
      )
    )
    Google::Apis::YoutubeV3::ListSubscriptionResponse.new(
      items: Array.new(max_results, subscription),
      page_info: Google::Apis::YoutubeV3::PageInfo.new(total_results: max_results)
    )
  end

  # @return [Google::Apis::YoutubeV3::SearchListsResponse]
  def search_channel(_query, max_results:, token:)
    search_result = Google::Apis::YoutubeV3::SearchResult.new(
      snippet: Google::Apis::YoutubeV3::SearchResultSnippet.new(
        channel_id: 'dummy_channel_id',
        title: 'dummy channel',
        description: 'dummy description',
        thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
          default: Google::Apis::YoutubeV3::Thumbnail.new(url: 'https://example.com/thumbnail/dummy')
        )
      )
    )
    Google::Apis::YoutubeV3::SearchListsResponse.new(
      items: Array.new(max_results, search_result),
      page_info: Google::Apis::YoutubeV3::PageInfo.new(total_results: max_results)
    )
  end
end
