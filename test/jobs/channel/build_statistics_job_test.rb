require 'test_helper'

class Channel::BuildStatisticsJobTest < ActiveSupport::TestCase
  def test_before_enqueue
    assert Channel::BuildStatisticsJob.before_enqueue

    jobs = [
      {
        'class' => Channel::BuildStatisticsJob.name,
        'args' => [
          {
            'channel_id' => 'test_channel_id'
          }
        ]
      }
    ]
    JobUtils.stub(:peek, jobs) do
      params = {'channel_id' => 'test_channel_id'}
      assert_not Channel::BuildStatisticsJob.before_enqueue(params)
    end
  end

  def test_perform
    channel = channels(:channel1)
    assert_nothing_raised do
      assert_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
  end

  def test_perform_error
    channel = channels(:error_channel)
    assert_raise Google::Apis::ClientError do
      assert_no_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end

    channel = channels(:non_existing_channel)
    assert_not channel.disabled?
    assert_raise Mishina::Youtube::NoChannelError do
      assert_no_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
    assert channel.reload.disabled?, 'disabled if the channel does not exist'
    assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
  end
end
