# frozen_string_literal: true

module Mishina
  module Youtube
    module Mock
      class Service
        attr_accessor :service

        def initialize(_options = {})
          self
        end

        def statistics(channel_id)
          case channel_id
          when /error/
            client_error_response
          when /blank/
            no_channel_response(channel_id)
          when /hidden_subscriber/
            hidden_subscriber_channel_statistics_response
          else
            channel_statistics_response
          end
        end

        def snippet(channel_id)
          case channel_id
          when /error/
            client_error_response
          when /blank/
            no_channel_response(channel_id)
          else
            channel_snippet_response
          end
        end

        # @return [Google::Apis::YoutubeV3::ListSubscriptionResponse]
        def subscriptions(token:, max_results:)
          max_results = max_results.to_i
          start = suffix_number(token) * max_results
          subscriptions = Array.new(max_results) do |i|
            n = start + i
            Google::Apis::YoutubeV3::Subscription.new(
              snippet: Google::Apis::YoutubeV3::SubscriptionSnippet.new(
                resource_id: Google::Apis::YoutubeV3::ResourceId.new(
                  channel_id: "dummy_channel_id_#{n}"
                ),
                title: "dummy channel #{n}",
                description: "dummy description for dummy channel #{n}. Token: #{token}",
                thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
                  default: Google::Apis::YoutubeV3::Thumbnail.new(url: "https://example.com/thumbnail/dummy#{n}")
                )
              )
            )
          end
          Google::Apis::YoutubeV3::ListSubscriptionResponse.new(
            items: subscriptions,
            prev_page_token: dummy_prev_page_token(token: token),
            next_page_token: dummy_next_page_token(token: token),
            page_info: Google::Apis::YoutubeV3::PageInfo.new(total_results: max_results)
          )
        end

        # @return [Google::Apis::YoutubeV3::SearchListsResponse]
        def search_channel(query, max_results:, token:)
          max_results = max_results.to_i
          start = suffix_number(token) * max_results
          search_results = Array.new(max_results) do |i|
            n = start + i
            Google::Apis::YoutubeV3::SearchResult.new(
              snippet: Google::Apis::YoutubeV3::SearchResultSnippet.new(
                channel_id: "dummy_channel_id_#{n}",
                title: "dummy channel #{n}",
                description: "dummy description for dummy channel #{n}. Query: #{query} Token: #{token}",
                thumbnails: Google::Apis::YoutubeV3::ThumbnailDetails.new(
                  default: Google::Apis::YoutubeV3::Thumbnail.new(url: "https://example.com/thumbnail/dummy#{n}")
                )
              )
            )
          end
          Google::Apis::YoutubeV3::SearchListsResponse.new(
            items: search_results,
            prev_page_token: dummy_prev_page_token(token: token),
            next_page_token: dummy_next_page_token(token: token),
            page_info: Google::Apis::YoutubeV3::PageInfo.new(total_results: max_results)
          )
        end

        private

        def client_error_response
          Mishina::Youtube::ServiceResponse.new(
            Consts::Statuses::ERROR,
            nil,
            Google::Apis::ClientError.new('Invalid request')
          )
        end

        def no_channel_response(channel_id)
          Mishina::Youtube::ServiceResponse.new(
            Consts::Statuses::BLANK,
            nil,
            Mishina::Youtube::NoChannelError.new(channel_id)
          )
        end

        def hidden_subscriber_channel_statistics_response
          Mishina::Youtube::ServiceResponse.new(
            Consts::Statuses::OK,
            Google::Apis::YoutubeV3::ChannelStatistics.new(
              hidden_subscriber_count: true,
              video_count: 50,
              view_count: 5000
            ),
            nil
          )
        end

        def channel_statistics_response
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

        def channel_snippet_response
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

        def dummy_prev_page_token(token: nil)
          token ||= 'dummy_token_0'
          start = suffix_number(token)
          return if start < 1

          "dummy_token_#{start - 1}"
        end

        def dummy_next_page_token(token: nil)
          token ||= 'dummy_token_0'
          start = suffix_number(token)
          "dummy_token_#{start + 1}"
        end

        def suffix_number(string)
          m = string&.match(/(?<number>\d+)\z/)
          m ? m[:number].to_i : 0
        end
      end
    end
  end
end
