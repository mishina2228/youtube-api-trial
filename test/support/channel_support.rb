module ChannelSupport
  def build_channel_with_statistics
    c = Channel.new(valid_params)
    c.channel_statistics.build(statistics_valid_params)
    c
  end

  def valid_params
    {
      channel_id: SecureRandom.hex(8),
      title: "Channel-#{SecureRandom.hex(8)}",
      description: 'dummy description',
      thumbnail_url: 'https://example.com/thumbnail/dummy',
      published_at: Time.current
    }
  end

  def statistics_valid_params
    {
      view_count: rand(100..10000),
      subscriber_count: rand(100..10000),
      video_count: rand(100..10000)
    }
  end
end
