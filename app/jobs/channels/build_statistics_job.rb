# frozen_string_literal: true

module Channels
  class BuildStatisticsJob
    @queue = :normal

    def self.before_enqueue(params = {})
      jobs = JobUtils.peek(@queue, 0, 100)
      jobs.each do |job|
        next if job['class'] != name

        args = job['args'].first || {}
        return false if params['channel_id'] == args['channel_id']
      end
      true
    end

    def self.perform(options = {})
      channel = Channel.find(options['channel_id'])
      raise Mishina::Youtube::DisabledChannelError, channel.channel_id if channel.disabled?

      begin
        channel.transaction do
          cs = channel.build_statistics!
          channel.update_latest_statistics!(cs)
        end
      rescue Mishina::Youtube::NoChannelError => e
        # No need to retry
        # NOTE: YouTube API sometimes returns incorrect results though...
        raise e
      rescue => e
        retry_count = options['retry'].to_i
        raise e unless retry_count < Consts::Job::RETRY_MAX_COUNT

        seconds = 3 * 10**retry_count
        JobUtils.enqueue_in(seconds, self, options.merge('retry' => retry_count + 1))
      end

      Rails.logger.info %(Acquired statistics for channel "#{channel.title}")
    end
  end
end
