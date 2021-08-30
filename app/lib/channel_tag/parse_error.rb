module ChannelTag
  class ParseError < StandardError
    DEFAULT_MESSAGE = <<~MSG.strip.freeze
      Please specify a json string like the following example:

      [{"value":"tag1"},{"value":"tag2"}]
    MSG

    def initialize(msg = DEFAULT_MESSAGE)
      super
    end
  end
end
