# frozen_string_literal: true

module ChannelSupport
  def build_channel_with_statistics
    c = Channel.new(valid_channel_params)
    c.channel_statistics.build(valid_statistics_params)
    c
  end

  def valid_channel_params
    {
      channel_id: SecureRandom.hex(8),
      title: "Channel-#{SecureRandom.hex(8)}",
      description: 'dummy description',
      thumbnail_url: 'https://example.com/thumbnail/dummy',
      published_at: Time.current
    }
  end

  def valid_statistics_params
    {
      view_count: rand(100..10_000),
      subscriber_count: rand(100..10_000),
      video_count: rand(100..10_000)
    }
  end
end
