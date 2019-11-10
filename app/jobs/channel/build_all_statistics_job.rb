class Channel::BuildAllStatisticsJob
  @queue = :normal

  def self.before_enqueue(_params = {})
    jobs = JobUtils.peek(@queue, 0, 100)
    jobs.each do |job|
      return false if job['class'] == name
    end
    true
  end

  def self.perform(_options = {})
    Channel.where(disabled: false).find_each do |channel|
      JobUtils.enqueue(Channel::BuildStatisticsJob, 'channel_id' => channel.id)
    end
  end
end
