require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  test 'use_oauth2?' do
    assert ss = system_setting

    SystemSetting.destroy_all
    assert_not Channel.use_oauth2?

    assert ss.update(auth_method: :api_key)
    assert_not Channel.use_oauth2?

    assert ss.update(auth_method: :oauth2)
    assert ss.oauth2?

    Channel.stub(:system_setting, ss) do
      ss.stub(:oauth2_configured?, false) do
        assert_not ss.oauth2_configured?
        assert_not Channel.use_oauth2?
      end
      ss.stub(:oauth2_configured?, true) do
        assert ss.oauth2_configured?
        assert Channel.use_oauth2?
      end
    end
  end

  test 'validation' do
    channel = Channel.new(valid_params)
    assert channel.valid?

    channel = Channel.new(valid_params.merge(channel_id: nil))
    assert channel.invalid?

    channel = Channel.new(valid_params.merge(thumbnail_url: 'abc'))
    assert channel.invalid?
    channel = Channel.new(valid_params.merge(thumbnail_url: nil))
    assert channel.valid?
  end

  test 'should extract channel id from channel_id in the valid format' do
    valid_channel_ids = %w(
      abc
      abc?sub_confirmation=1
      https://www.youtube.com/channel/abc
      www.youtube.com/channel/abc
      https://www.youtube.com/channel/abc/featured
      www.youtube.com/channel/abc/featured
      https://www.youtube.com/channel/abc?sub_confirmation=1
      www.youtube.com/channel/abc?sub_confirmation=1
    )

    valid_channel_ids.each do |channel_id|
      channel = Channel.new(channel_id: channel_id)
      assert_equal 'abc', channel.channel_id
    end
  end

  test 'should not extract channel id from channel_id in the invalid format' do
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

  test 'youtube_service should return mock in the test environment' do
    channel = channels(:channel1)
    ret = channel.youtube_service
    assert ret.is_a?(Mishina::Youtube::Mock::Service), 'use mock in the test environment'
  end

  test "calling youtube_service without any SystemSetting's records should raise error" do
    channel = channels(:channel1)
    SystemSetting.delete_all
    assert_raise do
      channel.youtube_service
    end
  end

  test "build_statistics should create a ChannelStatistic's record" do
    channel = channels(:channel1)
    assert_difference -> {channel.channel_statistics.count} do
      channel.build_statistics!
    end
    cs = channel.channel_statistics.first
    assert_equal 100_000, cs.subscriber_count
  end

  test 'subscriber_count should be zero if hidden_subscriber_count is true' do
    channel = channels(:hidden_subscriber_channel)
    assert_difference -> {channel.channel_statistics.count} do
      channel.build_statistics!
    end
    cs = channel.channel_statistics.first
    assert_equal 0, cs.subscriber_count
  end

  test 'build_statistics should raise error if the channel is invalid' do
    channel = channels(:error_channel)
    assert_no_difference -> {channel.channel_statistics.count} do
      assert_raise Google::Apis::ClientError do
        assert_not channel.build_statistics!
      end
    end
  end

  test 'build_statistics should raise error if the channel no longer exists' do
    channel = channels(:non_existing_channel)
    assert_no_difference -> {channel.channel_statistics.count} do
      err = assert_raise Mishina::Youtube::NoChannelError do
        assert_not channel.build_statistics!
      end
      assert_includes err.message, "title = #{channel.title}"
    end
  end

  test 'update_snippet should update attributes of a channel' do
    channel = channels(:channel1)
    before_channel = channel.dup
    assert_difference -> {channel.channel_snippets.count} do
      channel.update_snippet!
    end
    channel.reload
    assert_not_equal channel.title, before_channel.title
    assert_not_equal channel.description, before_channel.description
    assert_not_equal channel.thumbnail_url, before_channel.thumbnail_url
    assert_not_equal channel.published_at, before_channel.published_at
  end

  test 'update_snippet should raise error if the channel is invalid' do
    channel = channels(:error_channel)
    assert_raise Google::Apis::ClientError do
      assert_not channel.update_snippet!
    end
  end

  test 'update_snippet should raise error if the channel no longer exists' do
    channel = channels(:non_existing_channel)
    e = assert_raise Mishina::Youtube::NoChannelError do
      assert_not channel.update_snippet!
    end
    assert_includes e.message, "title = #{channel.title}"
  end

  test 'medium_thumbnail_url' do
    channel = channels(:channel1)
    thumbnail_url = 'https://yt3.ggpht.com/-4nB6EusJ1Iw/AAAAAAAAAAI/AAAAAAAAAAA/coEXMA5Pjrg/s88-c-k-no-mo-rj-c0xffffff/photo.jpg'
    channel.thumbnail_url = thumbnail_url
    expected = 'https://yt3.ggpht.com/-4nB6EusJ1Iw/AAAAAAAAAAI/AAAAAAAAAAA/coEXMA5Pjrg/s240-c-k-no-mo-rj-c0xffffff/photo.jpg'
    assert_equal expected, channel.medium_thumbnail_url

    thumbnail_url = 'https://yt3.ggpht.com/a/AGF-l79ixJhX3qrps2VymdF7R-Mq_z86tUJGHxY8qg=s88-c-k-c0xffffffff-no-rj-mo'
    channel.thumbnail_url = thumbnail_url
    expected = 'https://yt3.ggpht.com/a/AGF-l79ixJhX3qrps2VymdF7R-Mq_z86tUJGHxY8qg=s240-c-k-c0xffffffff-no-rj-mo'
    assert_equal expected, channel.medium_thumbnail_url
  end

  test 'high_thumbnail_url' do
    channel = channels(:channel1)
    thumbnail_url = 'https://yt3.ggpht.com/-4nB6EusJ1Iw/AAAAAAAAAAI/AAAAAAAAAAA/coEXMA5Pjrg/s88-c-k-no-mo-rj-c0xffffff/photo.jpg'
    channel.thumbnail_url = thumbnail_url
    expected = 'https://yt3.ggpht.com/-4nB6EusJ1Iw/AAAAAAAAAAI/AAAAAAAAAAA/coEXMA5Pjrg/s800-c-k-no-mo-rj-c0xffffff/photo.jpg'
    assert_equal expected, channel.high_thumbnail_url

    thumbnail_url = 'https://yt3.ggpht.com/a/AGF-l79ixJhX3qrps2VymdF7R-Mq_z86tUJGHxY8qg=s88-c-k-c0xffffffff-no-rj-mo'
    channel.thumbnail_url = thumbnail_url
    expected = 'https://yt3.ggpht.com/a/AGF-l79ixJhX3qrps2VymdF7R-Mq_z86tUJGHxY8qg=s800-c-k-c0xffffffff-no-rj-mo'
    assert_equal expected, channel.high_thumbnail_url
  end

  test 'enabled?' do
    channel = channels(:channel1)
    channel.disabled = false
    assert channel.enabled?
  end

  test 'tag_list_json' do
    channel = channels(:channel1)
    channel.tag_list = %w[tag1 tag2]
    assert_equal %([{"value":"tag1"},{"value":"tag2"}]), channel.tag_list_json
  end

  def valid_params
    {channel_id: 'abc', thumbnail_url: 'https://www.example.com'}
  end
end
