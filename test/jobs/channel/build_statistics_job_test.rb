require 'test_helper'

class Channel::BuildStatisticsJobTest < ActiveSupport::TestCase
  def test_perform
    channel = channels(:チャンネル1)
    assert_nothing_raised do
      assert_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
  end

  def test_perform_error
    channel = channels(:エラーチャンネル)
    assert_raise Google::Apis::ClientError do
      assert_no_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end

    channel = channels(:存在しないチャンネル)
    assert_not channel.disabled?
    assert_raise Mishina::Youtube::NoChannelError do
      assert_no_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
    assert channel.reload.disabled?, 'チャンネルが存在しなかった場合はdisabledになること'
    assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
  end
end
