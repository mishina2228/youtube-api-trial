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

  def test_channel_id=
    channel = Channel.new(channel_id: 'abc')
    assert_equal channel.channel_id, 'abc'

    channel = Channel.new(channel_id: 'https://www.youtube.com/channel/abc')
    assert_equal channel.channel_id, 'abc'

    channel = Channel.new(channel_id: 'www.youtube.com/channel/abc')
    assert_equal channel.channel_id, 'abc'

    channel = Channel.new(channel_id: nil)
    assert_nil channel.channel_id
    channel = Channel.new(channel_id: '')
    assert_nil channel.channel_id
    channel = Channel.new(channel_id: '1 2 3')
    assert_nil channel.channel_id
  end

  def valid_params
    {channel_id: 'abc', thumbnail_url: 'https://www.example.com'}
  end
end
