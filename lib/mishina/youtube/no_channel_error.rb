class Mishina::Youtube::NoChannelError < StandardError
  def initialize(channel_id)
    super("Could not find the channel. channel_id = #{channel_id}")
  end
end
