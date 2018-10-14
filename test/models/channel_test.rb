require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  def test_validation
    channel = Channel.new(valid_params)
    assert channel.valid?

    channel = Channel.new(valid_params.merge(channel_id: nil))
    assert channel.invalid?

    channel = Channel.new(valid_params.merge(thumbnail_url: 'abc'))
    assert channel.invalid?
    channel = Channel.new(valid_params.merge(thumbnail_url: nil))
    assert channel.valid?
  end

  def test_channel_id_valid
    valid_channel_ids = %w(
      abc
      https://www.youtube.com/channel/abc
      www.youtube.com/channel/abc
      https://www.youtube.com/channel/abc/featured
      www.youtube.com/channel/abc/featured
    )

    valid_channel_ids.each do |channel_id|
      channel = Channel.new(channel_id: channel_id)
      assert_equal 'abc', channel.channel_id
    end
  end

  def test_channel_id_invalid
    invalid_channel_ids = [
      nil, '', '1 2 3'
    ]

    invalid_channel_ids += %w(
      https://www.youtube.com/
      https://www.youtube.com/user/abc
      https://www.youtube.com/watch?v=abc
      https://example.com/abc
    )

    invalid_channel_ids.each do |channel_id|
      channel = Channel.new(channel_id: channel_id)
      assert channel.channel_id.blank?
    end
  end

  def valid_params
    {channel_id: 'abc', thumbnail_url: 'https://www.example.com'}
  end
end
