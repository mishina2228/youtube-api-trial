# frozen_string_literal: true

module Mishina
  module Youtube
    class DisabledChannelError < StandardError
      def initialize(channel_id)
        channel = Channel.find_by(channel_id: channel_id)
        message = "This channel is disabled. channel_id = #{channel_id}"
        message += " title = #{channel.title}" if channel
        super(message)
      end
    end
  end
end
