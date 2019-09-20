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
    raise "チャンネル「#{channel.title}」の情報更新に失敗しました。" unless channel.update_snippet

    Rails.logger.info("チャンネル「#{channel.title}」の情報更新が終了しました。")
  end
end
