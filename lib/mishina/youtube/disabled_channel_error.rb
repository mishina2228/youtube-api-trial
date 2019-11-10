class Mishina::Youtube::DisabledChannelError < StandardError
  def initialize(channel_id)
    super("This channel is disabled. channel_id = #{channel_id}")
  end
end
