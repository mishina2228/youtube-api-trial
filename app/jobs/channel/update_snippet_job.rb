class Channel::UpdateSnippetJob
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
        channel.update_snippet!
      end
    rescue Mishina::Youtube::NoChannelError => e
      channel.update!(disabled: true)
      raise e
    rescue => e
      retry_count = options['retry'].to_i
      raise e unless retry_count < Consts::Job::RETRY_MAX_COUNT

      seconds = 3 * 10**retry_count
      JobUtils.enqueue_in(seconds, self, options.merge('retry' => retry_count + 1))
    end

    Rails.logger.info %(Updated information of channel "#{channel.title}")
  end
end
