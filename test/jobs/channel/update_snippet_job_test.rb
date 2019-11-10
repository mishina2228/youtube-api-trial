require 'test_helper'

class Channel::UpdateSnippetJobTest < ActiveSupport::TestCase
  def test_perform
    channel = channels(:チャンネル1)
    before_description = channel.description
    assert_nothing_raised do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_not_equal channel.reload.description, before_description
  end

  def test_perform_error
    channel = channels(:エラーチャンネル)
    assert_nil channel.description
    assert_raise Google::Apis::ClientError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description

    channel = channels(:存在しないチャンネル)
    assert_nil channel.description
    assert_not channel.disabled?
    assert_raise Mishina::Youtube::NoChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description
    assert channel.disabled?, 'チャンネルが存在しなかった場合はdisabledになること'
    assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
  end
end
