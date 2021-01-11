require 'test_helper'
require 'google/apis/errors'

class Channel::BuildStatisticsJobTest < ActiveSupport::TestCase
  test 'before_enqueue' do
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

  test 'channel statistics increases by one' do
    channel = channels(:channel1)
    assert_nothing_raised do
      assert_difference -> {channel.channel_statistics.count} do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
  end

  test 'fail if the channel is not existed' do
    channel = channels(:non_existing_channel)
    assert_not channel.disabled?
    assert_no_difference -> {channel.channel_statistics.count} do
      e = assert_raise Mishina::Youtube::NoChannelError do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
      assert_includes e.message, "title = #{channel.title}"
    end

    assert channel.reload.disabled?, 'the channel is disabled if it does not exist'
    e = assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
    end
    assert_includes e.message, "title = #{channel.title}"
  end

  test 'fail if the client error occurred' do
    channel = channels(:error_channel)
    assert_no_difference -> {channel.channel_statistics.count} do
      assert_raise Google::Apis::ClientError do
        Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
      end
    end
  end

  test 'retry this job if the transmission error occurred' do
    channel = channels(:channel1)
    job_utils_mock = MiniTest::Mock.new
    job_utils_mock.expect(:call, nil) do |seconds_from_now, klass, options|
      assert_equal 3 * 10**0, seconds_from_now
      assert_equal Channel::BuildStatisticsJob, klass
      assert_equal 1, options['retry']
    end
    expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

    Channel.stub(:find, ->(_channel_id) {channel}) do
      channel.stub(:build_statistics!, expected_error) do
        JobUtils.stub(:enqueue_in, job_utils_mock) do
          Channel::BuildStatisticsJob.perform('channel_id' => channel.id)
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
          Channel::BuildStatisticsJob.perform(
            'channel_id' => channel.id, 'retry' => Consts::Job::RETRY_MAX_COUNT
          )
        end
      end
    end
  end
end
