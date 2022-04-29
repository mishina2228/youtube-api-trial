# frozen_string_literal: true

module Mishina
  module Youtube
    class NoChannelError < StandardError
      def initialize(channel_id)
        channel = Channel.find_by(channel_id: channel_id)
        message = "Could not find the channel. channel_id = #{channel_id}"
        message += " title = #{channel.title}" if channel
        super(message)
      end
    end
  end
end
