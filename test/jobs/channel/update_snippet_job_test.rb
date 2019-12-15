require 'test_helper'

class Channel::UpdateSnippetJobTest < ActiveSupport::TestCase
  def test_perform
    channel = channels(:channel1)
    before_description = channel.description
    assert_nothing_raised do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_not_equal channel.reload.description, before_description
  end

  def test_perform_error
    channel = channels(:error_channel)
    assert_nil channel.description
    assert_raise Google::Apis::ClientError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description

    channel = channels(:non_existing_channel)
    assert_nil channel.description
    assert_not channel.disabled?
    assert_raise Mishina::Youtube::NoChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description
    assert channel.disabled?, 'disabled if the channel does not exist'
    assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
  end
end
