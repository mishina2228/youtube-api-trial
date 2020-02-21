require 'test_helper'

class Channel::UpdateSnippetJobTest < ActiveSupport::TestCase
  test 'before_enqueue' do
    assert Channel::UpdateSnippetJob.before_enqueue

    jobs = [
      {
        'class' => Channel::UpdateSnippetJob.name,
        'args' => [
          {
            'channel_id' => 'test_channel_id'
          }
        ]
      }
    ]
    JobUtils.stub(:peek, jobs) do
      params = {'channel_id' => 'test_channel_id'}
      assert_not Channel::UpdateSnippetJob.before_enqueue(params)
    end
  end

  test 'channel snippet should be updated' do
    channel = channels(:channel1)
    before_description = channel.description
    assert_nothing_raised do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_not_equal channel.reload.description, before_description
  end

  test 'fail if the channel is not existed' do
    channel = channels(:non_existing_channel)
    assert_nil channel.description
    assert_not channel.disabled?
    assert_raise Mishina::Youtube::NoChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end

    assert_nil channel.reload.description
    assert channel.disabled?, 'the channel is disabled if it does not exist'
    assert_raise Mishina::Youtube::DisabledChannelError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
  end

  test 'fail if client error occurred' do
    channel = channels(:error_channel)
    assert_nil channel.description
    assert_raise Google::Apis::ClientError do
      Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
    end
    assert_nil channel.reload.description
  end

  test 'retry this job if the transmission error occurred' do
    channel = channels(:channel1)
    job_utils_mock = MiniTest::Mock.new
    job_utils_mock.expect(:call, nil) do |seconds_from_now, klass, options|
      assert_equal 3 * 10**0, seconds_from_now
      assert_equal Channel::UpdateSnippetJob, klass
      assert_equal 1, options['retry']
    end
    expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

    Channel.stub(:find, ->(_channel_id) {channel}) do
      channel.stub(:update_snippet!, expected_error) do
        JobUtils.stub(:enqueue_in, job_utils_mock) do
          Channel::UpdateSnippetJob.perform('channel_id' => channel.id)
        end
      end
    end

    assert job_utils_mock.verify
  end

  test 'fail if the transmission error occurred and retry limit exceeded' do
    channel = channels(:channel1)
    expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

    Channel.stub(:find, ->(_channel_id) {channel}) do
      channel.stub(:update_snippet!, expected_error) do
        assert_raise Google::Apis::TransmissionError do
          Channel::UpdateSnippetJob.perform(
            'channel_id' => channel.id, 'retry' => Consts::Job::RETRY_MAX_COUNT
          )
        end
      end
    end
  end
end
