require 'test_helper'

class Search::ChannelTest < ActiveSupport::TestCase
  setup do
    @c1 = channels(:channel1)
    @c2 = channels(:channel2)
  end

  test 'search by id' do
    channel = Search::Channel.new(ids: [@c1.id])
    ret = channel.search
    assert_includes ret, @c1
  end

  test 'search by title' do
    channel = Search::Channel.new(title: 'Channel')
    ret = channel.search
    assert_includes ret, @c1
    assert_includes ret, @c2

    channel = Search::Channel.new(title: 'Channel1')
    ret = channel.search
    assert_includes ret, @c1
    assert_not_includes ret, @c2
  end

  test 'search by from_date' do
    channel = Search::Channel.new(from_date: '2018-10-20')
    ret = channel.search
    assert_includes ret, @c1
    assert_includes ret, @c2

    channel = Search::Channel.new(from_date: '2018-10-21')
    ret = channel.search
    assert_not_includes ret, @c1
    assert_includes ret, @c2
  end

  test 'search by to_date' do
    channel = Search::Channel.new(to_date: '2018-12-21')
    ret = channel.search
    assert_includes ret, @c1
    assert_includes ret, @c2

    channel = Search::Channel.new(to_date: '2018-12-20')
    ret = channel.search
    assert_includes ret, @c1
    # TODO: improve date handling
    # assert_includes ret, @c2

    channel = Search::Channel.new(to_date: '2018-12-19')
    ret = channel.search
    assert_includes ret, @c1
    assert_not_includes ret, @c2
  end

  test 'search by order and direction' do
    channel = Search::Channel.new(order: 'title', direction: nil)
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a

    channel = Search::Channel.new(order: 'title', direction: 'desc')
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a

    channel = Search::Channel.new(order: 'title', direction: 'asc')
    ret = channel.search
    assert_equal [@c1, @c2], ret.to_a

    channel = Search::Channel.new(order: 'view_count', direction: 'desc')
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a

    channel = Search::Channel.new(order: nil, direction: nil)
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a, 'default order is descending number of subscribers'
  end

  test 'search by disabled' do
    assert @c2.update(disabled: true)

    channel = Search::Channel.new(disabled: nil)
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a

    channel = Search::Channel.new(disabled: '')
    ret = channel.search
    assert_equal [@c2, @c1], ret.to_a

    channel = Search::Channel.new(disabled: false)
    ret = channel.search
    assert_equal [@c1], ret.to_a

    channel = Search::Channel.new(disabled: true)
    ret = channel.search
    assert_equal [@c2], ret.to_a
  end

  test 'search by tag' do
    assert_includes @c1.tag_list, 'tag1'
    channel = Search::Channel.new(tag: 'tag1')
    ret = channel.search
    assert_equal [@c1], ret.to_a
  end

  test 'search by tag containing a comma' do
    @c1.tag_list.add('Monsters, Inc.')
    @c1.save!
    channel = Search::Channel.new(tag: 'Monsters, Inc.')
    ret = channel.search
    assert_equal [@c1], ret.to_a
  end

  test 'search by tag containing quotation marks' do
    @c1.tag_list.add("i'm lovin' it")
    @c1.save!
    channel = Search::Channel.new(tag: "i'm lovin' it")
    ret = channel.search
    assert_equal [@c1], ret.to_a
  end
end
