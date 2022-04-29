# frozen_string_literal: true

require 'test_helper'

class ChannelStatisticTest < ActiveSupport::TestCase
  test 'validation' do
    cs = ChannelStatistic.new(valid_params)
    assert cs.valid?

    cs = ChannelStatistic.new(valid_params.merge(view_count: nil))
    assert cs.invalid?
    cs = ChannelStatistic.new(valid_params.merge(view_count: 3.14))
    assert cs.invalid?

    cs = ChannelStatistic.new(valid_params.merge(subscriber_count: nil))
    assert cs.invalid?
    cs = ChannelStatistic.new(valid_params.merge(subscriber_count: 3.14))
    assert cs.invalid?

    cs = ChannelStatistic.new(valid_params.merge(video_count: nil))
    assert cs.invalid?
    cs = ChannelStatistic.new(valid_params.merge(video_count: 3.14))
    assert cs.invalid?
  end

  def valid_params
    channel = channels(:channel1)
    {
      channel_id: channel.id,
      view_count: 0,
      subscriber_count: 0,
      video_count: 0
    }
  end
end
