module ChannelTag
  class Parser < ActsAsTaggableOn::GenericParser
    def parse
      ActsAsTaggableOn::TagList.new.tap do |tag_list|
        json = parse_json_string(@tag_list.to_s)
        tag_list.add(json.map {|h| h['value']}.compact_blank.map(&:strip))
      end
    end

    private

    def parse_json_string(string)
      json = JSON.parse(string)
      raise ChannelTag::ParseError unless json.is_a?(Array) && json.all? {|h| h.respond_to?(:key?) && h.key?('value')}

      json
    rescue JSON::ParserError
      raise ChannelTag::ParseError
    end
  end
end
