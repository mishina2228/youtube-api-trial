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

  def test_youtube_service
    channel = channels(:チャンネル1)
    ret = channel.youtube_service
    assert ret.is_a?(::Mock::Service), 'テスト環境ではmockを使用すること'
  end

  def test_youtube_service_no_system_setting
    channel = channels(:チャンネル1)
    SystemSetting.delete_all
    assert_raise do
      channel.youtube_service
    end
  end

  def test_build_statistics
    channel = channels(:チャンネル1)
    assert_difference -> {ChannelStatistic.count} do
      channel.build_statistics!
    end
  end

  def test_build_statistics_error
    channel = channels(:エラーチャンネル)
    assert_raise Google::Apis::ClientError do
      assert_no_difference -> {ChannelStatistic.count} do
        assert_not channel.build_statistics!
      end
    end
  end

  def test_build_statistics_blank
    channel = channels(:存在しないチャンネル)
    assert_raise Youtube::NoChannelError do
      assert_no_difference -> {ChannelStatistic.count} do
        assert_not channel.build_statistics!
      end
    end
  end

  def test_update_snippet
    channel = channels(:チャンネル1)
    before_channel = channel.dup
    channel.update_snippet!
    channel.reload
    assert_not_equal channel.title, before_channel.title
    assert_not_equal channel.description, before_channel.description
    assert_not_equal channel.thumbnail_url, before_channel.thumbnail_url
    assert_not_equal channel.published_at, before_channel.published_at
  end

  def test_update_snippet_error
    channel = channels(:エラーチャンネル)
    assert_raise Google::Apis::ClientError do
      assert_not channel.update_snippet!
    end
  end

  def test_update_snippet_blank
    channel = channels(:存在しないチャンネル)
    assert_raise Youtube::NoChannelError do
      assert_not channel.update_snippet!
    end
  end

  def valid_params
    {channel_id: 'abc', thumbnail_url: 'https://www.example.com'}
  end
end
