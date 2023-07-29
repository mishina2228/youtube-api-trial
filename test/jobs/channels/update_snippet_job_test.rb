# frozen_string_literal: true

require 'test_helper'

module Channels
  class UpdateSnippetJobTest < ActiveSupport::TestCase
    test 'before_enqueue' do
      assert Channels::UpdateSnippetJob.before_enqueue

      jobs = [
        {
          'class' => Channels::UpdateSnippetJob.name,
          'args' => [
            {
              'channel_id' => 'test_channel_id'
            }
          ]
        }
      ]
      JobUtils.stub(:peek, jobs) do
        params = {'channel_id' => 'test_channel_id'}
        assert_not Channels::UpdateSnippetJob.before_enqueue(params)
      end
    end

    test 'channel snippet should be updated' do
      channel = channels(:channel1)
      before_description = channel.description
      Channels::UpdateSnippetJob.perform('channel_id' => channel.id)
      assert_not_equal channel.reload.description, before_description
    end

    test 'fail if the channel is not existed' do
      channel = channels(:non_existing_channel)
      assert_nil channel.description
      assert_not channel.disabled?
      e = assert_raise Mishina::Youtube::NoChannelError do
        Channels::UpdateSnippetJob.perform('channel_id' => channel.id)
      end
      assert_includes e.message, "title = #{channel.title}"
      assert_nil channel.reload.description
      assert_not channel.disabled?, 'the channel is not disabled even if it does not exist'
    end

    test 'fail if the channel is disabled' do
      channel = channels(:disabled_channel)
      e = assert_raise Mishina::Youtube::DisabledChannelError do
        Channels::UpdateSnippetJob.perform('channel_id' => channel.id)
      end
      assert_includes e.message, "title = #{channel.title}"
    end

    test 'fail if client error occurred' do
      channel = channels(:error_channel)
      assert_nil channel.description
      assert_raise Google::Apis::ClientError do
        Channels::UpdateSnippetJob.perform('channel_id' => channel.id)
      end
      assert_nil channel.reload.description
    end

    test 'retry this job if the transmission error occurred' do
      channel = channels(:channel1)
      job_utils_mock = Minitest::Mock.new
      job_utils_mock.expect(:call, nil) do |seconds_from_now, klass, options|
        assert_equal 3 * 10**0, seconds_from_now
        assert_equal Channels::UpdateSnippetJob, klass
        assert_equal 1, options['retry']
      end
      expected_error = -> {raise Google::Apis::TransmissionError, 'mock error'}

      Channel.stub(:find, ->(_channel_id) {channel}) do
        channel.stub(:update_snippet!, expected_error) do
          JobUtils.stub(:enqueue_in, job_utils_mock) do
            Channels::UpdateSnippetJob.perform('channel_id' => channel.id)
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
            Channels::UpdateSnippetJob.perform(
              'channel_id' => channel.id, 'retry' => Consts::Job::RETRY_MAX_COUNT
            )
          end
        end
      end
    end
  end
end
