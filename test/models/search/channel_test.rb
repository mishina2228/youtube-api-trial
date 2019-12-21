require 'test_helper'

class Search::ChannelTest < ActiveSupport::TestCase
  setup do
    @c1 = channels(:channel1)
    @c2 = channels(:channel2)
  end

  def test_search_id
    channel = Search::Channel.new(ids: [@c1.id])
    ret = channel.search
    assert_includes ret, @c1
  end

  def test_search_title
    channel = Search::Channel.new(title: 'Channel')
    ret = channel.search
    assert_includes ret, @c1
    assert_includes ret, @c2

    channel = Search::Channel.new(title: 'Channel1')
    ret = channel.search
    assert_includes ret, @c1
    assert_not_includes ret, @c2
  end

  def test_search_from_date
    channel = Search::Channel.new(from_date: '2018-10-20')
    ret = channel.search
    assert_includes ret, @c1
    assert_includes ret, @c2

    channel = Search::Channel.new(from_date: '2018-10-21')
    ret = channel.search
    assert_not_includes ret, @c1
    assert_includes ret, @c2
  end

  def test_search_to_date
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

  def test_search_order_direction
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
end
