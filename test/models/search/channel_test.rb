require 'test_helper'

module Search
  class ChannelTest < ActiveSupport::TestCase
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

    test 'search by from_date - a wrong argument should be ignored' do
      [nil, false, true, '', 'test', '2018-13-20'].each do |arg|
        channel = Search::Channel.new(from_date: arg)
        ret = channel.search
        assert_includes ret, @c1
        assert_includes ret, @c2
      end
    end

    test 'search by to_date' do
      channel = Search::Channel.new(to_date: '2018-12-21')
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(to_date: '2018-12-20')
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(to_date: '2018-12-19')
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2
    end

    test 'search by to_date - a wrong argument should be ignored' do
      [nil, false, true, '', 'test', '2018-13-20'].each do |arg|
        channel = Search::Channel.new(to_date: arg)
        ret = channel.search
        assert_includes ret, @c1
        assert_includes ret, @c2
      end
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

    test 'from_date returns beginning of the day' do
      expected = Date.new(2018, 10, 20).beginning_of_day
      ['2018-10-20', '2018-10-20 01:23:45', '2018-10-20T01:23:45+0900'].each do |arg|
        channel = Search::Channel.new(from_date: arg)
        assert_equal expected, channel.from_date
      end
    end

    test 'from_date accepts Date or Time' do
      expected = Date.new(2018, 10, 20).beginning_of_day
      [Date.parse('2018-10-20'), Time.zone.parse('2018-10-20T01:23:45+0900')].each do |arg|
        channel = Search::Channel.new(from_date: arg)
        assert_equal expected, channel.from_date
      end
    end

    test 'from_date returns nil when passing a wrong argument' do
      [nil, false, true, '', 'test', '2018-13-20'].each do |arg|
        channel = Search::Channel.new(from_date: arg)
        assert_nil channel.from_date
      end
    end

    test 'to_date returns end of the day' do
      expected = Date.new(2018, 12, 20).end_of_day
      ['2018-12-20', '2018-12-20 01:23:45', '2018-12-20T01:23:45+0900'].each do |arg|
        channel = Search::Channel.new(to_date: arg)
        assert_equal expected, channel.to_date
      end
    end

    test 'to_date accepts Date or Time' do
      expected = Date.new(2018, 12, 20).end_of_day
      [Date.parse('2018-12-20'), Time.zone.parse('2018-12-20T01:23:45+0900')].each do |arg|
        channel = Search::Channel.new(to_date: arg)
        assert_equal expected, channel.to_date
      end
    end

    test 'to_date returns nil when passing a wrong argument' do
      [nil, false, true, '', 'test', '2018-13-20'].each do |arg|
        channel = Search::Channel.new(to_date: arg)
        assert_nil channel.to_date
      end
    end

    test 'published_at returns nil or Range' do
      channel = Search::Channel.new
      assert_nil channel.published_at

      channel = Search::Channel.new(from_date: '2018-10-19')
      assert_equal channel.from_date.., channel.published_at

      channel = Search::Channel.new(to_date: '2018-12-19')
      assert_equal (..channel.to_date), channel.published_at

      channel = Search::Channel.new(from_date: '2018-10-19', to_date: '2018-12-19')
      assert_equal channel.from_date..channel.to_date, channel.published_at
    end
  end
end
