require 'test_helper'

class ChannelTag::ParserTest < ActiveSupport::TestCase
  setup do
    @channel = Channel.new
  end

  test 'a correct json string should be parsed' do
    @channel.tag_list.add([{value: 'tag1'}, {value: 'tag2'}].to_json, parser: ChannelTag::Parser)
    assert_equal %w[tag1 tag2], @channel.tag_list
  end

  test 'passing an array to tag_list should raise ParseError' do
    assert_raise ChannelTag::ParseError do
      @channel.tag_list.add(%w[tag1 tag2], parser: ChannelTag::Parser)
    end
  end

  test 'passing a comma-separated string to tag_list should raise ParseError' do
    assert_raise ChannelTag::ParseError do
      @channel.tag_list.add('tag1,tag2', parser: ChannelTag::Parser)
    end
  end

  test 'passing a incorrect json string should raise ParseError - not an array' do
    assert_raise ChannelTag::ParseError do
      @channel.tag_list.add({value: 'tag1'}.to_json, parser: ChannelTag::Parser)
    end
  end

  test 'passing a incorrect json string should raise ParseError - does not have key "value"' do
    assert_raise ChannelTag::ParseError do
      @channel.tag_list.add([{name: 'tag1'}, {name: 'tag2'}].to_json, parser: ChannelTag::Parser)
    end
  end

  test 'empty values should be ignored' do
    @channel.tag_list.add([{value: nil}, {value: ''}].to_json, parser: ChannelTag::Parser)
    assert_equal [], @channel.tag_list
  end

  test 'leading and trailing whitespaces should be ignored' do
    @channel.tag_list.add([{value: 'tag1 '}, {value: ' tag2'}, {value: ' tag3 '}].to_json, parser: ChannelTag::Parser)
    assert_equal %w[tag1 tag2 tag3], @channel.tag_list
  end

  test 'duplicated values should be ignored' do
    @channel.tag_list.add([{value: 'tag1'}, {value: 'tag1'}].to_json, parser: ChannelTag::Parser)
    assert_equal %w[tag1], @channel.tag_list
  end
end
