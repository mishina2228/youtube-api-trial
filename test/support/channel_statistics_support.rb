module ChannelStatisticsSupport
  def valid_params
    {
      view_count: rand(100..10000),
      subscriber_count: rand(100..10000),
      video_count: rand(100..10000)
    }
  end
end
