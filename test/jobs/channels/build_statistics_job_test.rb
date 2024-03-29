# frozen_string_literal: true

require 'test_helper'
require 'google/apis/errors'

module Channels
  class BuildStatisticsJobTest < ActiveSupport::TestCase
    test 'before_enqueue' do
      assert Channels::BuildStatisticsJob.before_enqueue

      jobs = [
        {
          'class' => Channels::BuildStatisticsJob.name,
          'args' => [
            {
              'channel_id' => 'test_channel_id'
            }
          ]
        }
      ]
      JobUtils.stub(:peek, jobs) do
        params = {'channel_id' => 'test_channel_id'}
        assert_not Channels::BuildStatisticsJob.before_enqueue(params)
      end
    end

    test 'channel statistics increases by one' do
      channel = channels(:channel1)
      assert_difference -> {channel.channel_statistics.count} do
        Channels::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end

    test 'both latest and second-latest channel statistics should be recorded if latest one have previously recorded' do
      channel = channels(:channel2)
      assert prev_latest_view_count = channel.latest_view_count
      assert prev_latest_subscriber_count = channel.latest_subscriber_count
      assert prev_latest_video_count = channel.latest_video_count
      assert prev_latest_acquired_at = channel.latest_acquired_at

      Channels::BuildStatisticsJob.perform('channel_id' => channel.id)

      latest_statistics = channel.channel_statistics.first
      assert_equal latest_statistics.view_count, channel.reload.latest_view_count
      assert_equal latest_statistics.subscriber_count, channel.latest_subscriber_count
      assert_equal latest_statistics.video_count, channel.latest_video_count
      assert_equal latest_statistics.created_at, channel.latest_acquired_at
      assert_equal prev_latest_view_count, channel.second_latest_view_count
      assert_equal prev_latest_subscriber_count, channel.second_latest_subscriber_count
      assert_equal prev_latest_video_count, channel.second_latest_video_count
      assert_equal prev_latest_acquired_at, channel.second_latest_acquired_at
    end

    test 'only latest channel statistics should be recorded if latest one have not been previously recorded' do
      channel = channels(:channel3)
      assert_nil channel.latest_view_count
      assert_nil channel.latest_subscriber_count
      assert_nil channel.latest_video_count
      assert_nil channel.latest_acquired_at

      Channels::BuildStatisticsJob.perform('channel_id' => channel.id)

      latest_statistics = channel.channel_statistics.first
      assert_equal latest_statistics.view_count, channel.reload.latest_view_count
      assert_equal latest_statistics.subscriber_count, channel.latest_subscriber_count
      assert_equal latest_statistics.video_count, channel.latest_video_count
      assert_equal latest_statistics.created_at, channel.latest_acquired_at
      assert_nil channel.second_latest_view_count
      assert_nil channel.second_latest_subscriber_count
      assert_nil channel.second_latest_video_count
      assert_nil channel.second_latest_acquired_at
    end

    test 'fail if the channel is not existed' do
      channel = channels(:non_existing_channel)
      assert_not channel.disabled?
      assert_no_difference -> {channel.channel_statistics.count} do
        e = assert_raise Mishina::Youtube::NoChannelError do
          Channels::BuildStatisticsJob.perform('channel_id' => channel.id)
        end
        assert_includes e.message, "title = #{channel.title}"
      end
      assert_not channel.reload.disabled?, 'the channel is not disabled even if it does not exist'
    end

    test 'fail if the channel is disabled' do
      channel = channels(:disabled_channel)
      e = assert_raise Mishina::Youtube::DisabledChannelError do
        Channels::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
      assert_includes e.message, "title = #{channel.title}"
    end

    test 'fail if the client error occurred' do
      channel = channels(:error_channel)
      assert_no_difference -> {channel.channel_statistics.count} do
        assert_raise Google::Apis::ClientError do
          Channels::BuildStatisticsJob.perform('channel_id' => channel.id)
        end
      end
    end

    test 'retry this job if the transmission error occurred' do
      channel = channels(:channel1)
      job_utils_mock = Minitest::Mock.new
      job_utils_mock.expect(:call, nil) do |seconds_from_now, klass, options|
        assert_equal 3 * 10**0, seconds_from_now
        assert_equal Channels::BuildStatisticsJob, klass
        assert_equal 1, options['retry']
      end
      expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

      Channel.stub(:find, ->(_channel_id) {channel}) do
        channel.stub(:build_statistics!, expected_error) do
          JobUtils.stub(:enqueue_in, job_utils_mock) do
            Channels::BuildStatisticsJob.perform('channel_id' => channel.id)
          end
        end
      end

      assert job_utils_mock.verify
    end

    test 'fail if the transmission error occurred and retry limit exceeded' do
      channel = channels(:channel1)
      expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

      Channel.stub(:find, ->(_channel_id) {channel}) do
        channel.stub(:build_statistics!, expected_error) do
          assert_raise Google::Apis::TransmissionError do
            Channels::BuildStatisticsJob.perform(
              'channel_id' => channel.id, 'retry' => Consts::Job::RETRY_MAX_COUNT
            )
          end
        end
      end
    end
  end
end
