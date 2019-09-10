class Channel::UpdateSnippetJob
  @queue = :normal

  def self.perform(options = {})
    channel = Channel.find(options['channel_id'])
    raise "チャンネル「#{channel.title}」の情報更新に失敗しました。" unless channel.update_snippet

    Rails.logger.info("チャンネル「#{channel.title}」の情報更新が終了しました。")
  end
end
