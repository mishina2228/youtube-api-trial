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
    assert_raise do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description

    channel = channels(:存在しないチャンネル)
    assert_nil channel.description
    assert_raise do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description
  end
end
