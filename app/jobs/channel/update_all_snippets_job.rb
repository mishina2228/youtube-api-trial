class Channel::UpdateAllSnippetsJob
  @queue = :normal

  def self.perform(_options = {})
    Channel.find_each do |channel|
      JobUtils.enqueue(Channel::UpdateSnippetJob, 'channel_id' => channel.id)
    end
  end
end
