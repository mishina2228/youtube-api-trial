class Channel::BuildAllStatisticsJob
  @queue = :normal

  def self.perform(_options = {})
    Channel.find_each do |channel|
      JobUtils.enqueue(Channel::BuildStatisticsJob, 'channel_id' => channel.id)
    end
  end
end
