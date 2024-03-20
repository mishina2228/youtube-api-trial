# frozen_string_literal: true

require 'test_helper'

module Search
  class ChannelTest < ActiveSupport::TestCase
    setup do
      @c1 = channels(:channel1)
      @c2 = channels(:channel2)
      @c3 = channels(:channel3)
      @no_statistics_channel = channels(:no_statistics_channel)
    end

    test 'search by id' do
      channel = Search::Channel.new(ids: [@c1.id])
      ret = channel.search
      assert_equal ret, [@c1]
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

    test 'search by title which includes wild cards' do
      channel = Search::Channel.new(title: '100%')
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2
      assert_not_includes ret, @c3

      channel = Search::Channel.new(title: '100_')
      ret = channel.search
      assert_not_includes ret, @c1
      assert_includes ret, @c2
      assert_not_includes ret, @c3

      channel = Search::Channel.new(title: '100\\')
      ret = channel.search
      assert_not_includes ret, @c1
      assert_not_includes ret, @c2
      assert_includes ret, @c3
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

    test 'search by subscriber_count_from' do
      channel = Search::Channel.new(subscriber_count_from: 1_000_002)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(subscriber_count_from: 1_000_003)
      ret = channel.search
      assert_not_includes ret, @c1
      assert_includes ret, @c2
    end

    test 'search by subscriber_count_to' do
      channel = Search::Channel.new(subscriber_count_to: 1_999_998)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(subscriber_count_to: 1_999_997)
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2
    end

    test 'search by video_count_from' do
      channel = Search::Channel.new(video_count_from: 1_000_001)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(video_count_from: 1_000_002)
      ret = channel.search
      assert_not_includes ret, @c1
      assert_includes ret, @c2
    end

    test 'search by video_count_to' do
      channel = Search::Channel.new(video_count_to: 1_999_999)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(video_count_to: 1_999_998)
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2
    end

    test 'search by view_count_from' do
      channel = Search::Channel.new(view_count_from: 1_000_003)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(view_count_from: 1_000_004)
      ret = channel.search
      assert_not_includes ret, @c1
      assert_includes ret, @c2
    end

    test 'search by view_count_to' do
      channel = Search::Channel.new(view_count_to: 1_999_997)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(view_count_to: 1_999_996)
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2
    end

    test 'search by order and direction' do
      channel = Search::Channel.new(order: 'title', direction: nil)
      ret = channel.search
      assert_operator ret.index(@c2), :<, ret.index(@c1)

      channel = Search::Channel.new(order: 'title', direction: 'desc')
      ret = channel.search
      assert_operator ret.index(@c2), :<, ret.index(@c1)

      channel = Search::Channel.new(order: 'title', direction: 'asc')
      ret = channel.search
      assert_operator ret.index(@c1), :<, ret.index(@c2)

      channel = Search::Channel.new(order: 'view_count', direction: 'desc')
      ret = channel.search
      assert_operator ret.index(@c2), :<, ret.index(@c1)

      channel = Search::Channel.new(order: nil, direction: nil)
      ret = channel.search
      assert_operator ret.index(@c2), :<, ret.index(@c1), 'default order is descending number of subscribers'
    end

    test 'search by disabled' do
      assert @c2.update(disabled: true)

      channel = Search::Channel.new(disabled: nil)
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(disabled: '')
      ret = channel.search
      assert_includes ret, @c1
      assert_includes ret, @c2

      channel = Search::Channel.new(disabled: false)
      ret = channel.search
      assert_includes ret, @c1
      assert_not_includes ret, @c2

      channel = Search::Channel.new(disabled: true)
      ret = channel.search
      assert_not_includes ret, @c1
      assert_includes ret, @c2
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

    test 'search results should include channels with only one statistics record' do
      assert_equal 1, @c3.channel_statistics.count
      channel = Search::Channel.new
      ret = channel.search
      assert_includes ret, @c3
    end

    test 'search results should include channels without statistics records' do
      assert_empty @no_statistics_channel.channel_statistics
      channel = Search::Channel.new
      ret = channel.search
      assert_includes ret, @no_statistics_channel
    end

    test 'search results should provide access to statistics info' do
      ret = Search::Channel.new(ids: [@c1.id]).search
      c = ret.first

      assert_equal @c1.latest_subscriber_count, c.latest_subscriber_count
      assert_equal @c1.latest_view_count, c.latest_view_count
      assert_equal @c1.latest_video_count, c.latest_video_count
      assert_equal @c1.latest_acquired_at, c.latest_acquired_at

      assert_equal @c1.second_latest_subscriber_count, c.second_latest_subscriber_count
      assert_equal @c1.second_latest_view_count, c.second_latest_view_count
      assert_equal @c1.second_latest_video_count, c.second_latest_video_count
      assert_equal @c1.second_latest_acquired_at, c.second_latest_acquired_at
    end

    test 'search results should provide access to statistics info - channel without statistics' do
      assert_empty @no_statistics_channel.channel_statistics
      ret = Search::Channel.new(ids: [@no_statistics_channel.id]).search
      c = ret.first

      assert_nil c.subscriber_count
      assert_nil c.view_count
      assert_nil c.video_count
      assert_nil c.latest_acquired_at

      assert_nil c.second_latest_subscriber_count
      assert_nil c.second_latest_view_count
      assert_nil c.second_latest_video_count
      assert_nil c.second_latest_acquired_at
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

    test 'subscriber_count_from returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(subscriber_count_from: arg)
        assert_equal 100, channel.subscriber_count_from
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(subscriber_count_from: arg)
        assert_equal 0, channel.subscriber_count_from
      end
    end

    test 'subscriber_count_from returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(subscriber_count_from: arg)
        assert_nil channel.subscriber_count_from
      end
    end

    test 'subscriber_count_to returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(subscriber_count_to: arg)
        assert_equal 100, channel.subscriber_count_to
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(subscriber_count_to: arg)
        assert_equal 0, channel.subscriber_count_to
      end
    end

    test 'subscriber_count_to returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(subscriber_count_to: arg)
        assert_nil channel.subscriber_count_to
      end
    end

    test 'subscriber_count returns nil or Range' do
      channel = Search::Channel.new
      assert_nil channel.subscriber_count

      channel = Search::Channel.new(subscriber_count_from: 100)
      assert_equal 100.., channel.subscriber_count

      channel = Search::Channel.new(subscriber_count_to: 200)
      assert_equal (..200), channel.subscriber_count

      channel = Search::Channel.new(subscriber_count_from: 100, subscriber_count_to: 200)
      assert_equal (100..200), channel.subscriber_count
    end

    test 'video_count_from returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(video_count_from: arg)
        assert_equal 100, channel.video_count_from
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(video_count_from: arg)
        assert_equal 0, channel.video_count_from
      end
    end

    test 'video_count_from returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(video_count_from: arg)
        assert_nil channel.video_count_from
      end
    end

    test 'video_count_to returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(video_count_to: arg)
        assert_equal 100, channel.video_count_to
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(video_count_to: arg)
        assert_equal 0, channel.video_count_to
      end
    end

    test 'video_count_to returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(video_count_to: arg)
        assert_nil channel.video_count_to
      end
    end

    test 'video_count returns nil or Range' do
      channel = Search::Channel.new
      assert_nil channel.video_count

      channel = Search::Channel.new(video_count_from: 100)
      assert_equal 100.., channel.video_count

      channel = Search::Channel.new(video_count_to: 200)
      assert_equal (..200), channel.video_count

      channel = Search::Channel.new(video_count_from: 100, video_count_to: 200)
      assert_equal (100..200), channel.video_count
    end

    test 'view_count_from returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(view_count_from: arg)
        assert_equal 100, channel.view_count_from
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(view_count_from: arg)
        assert_equal 0, channel.view_count_from
      end
    end

    test 'view_count_from returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(view_count_from: arg)
        assert_nil channel.view_count_from
      end
    end

    test 'view_count_to returns Integer' do
      [100, '100'].each do |arg|
        channel = Search::Channel.new(view_count_to: arg)
        assert_equal 100, channel.view_count_to
      end
      [0, '0'].each do |arg|
        channel = Search::Channel.new(view_count_to: arg)
        assert_equal 0, channel.view_count_to
      end
    end

    test 'view_count_to returns nil when passing a blank argument' do
      [nil, false, ''].each do |arg|
        channel = Search::Channel.new(view_count_to: arg)
        assert_nil channel.view_count_to
      end
    end

    test 'view_count returns nil or Range' do
      channel = Search::Channel.new
      assert_nil channel.view_count

      channel = Search::Channel.new(view_count_from: 100)
      assert_equal 100.., channel.view_count

      channel = Search::Channel.new(view_count_to: 200)
      assert_equal (..200), channel.view_count

      channel = Search::Channel.new(view_count_from: 100, view_count_to: 200)
      assert_equal (100..200), channel.view_count
    end
  end
end
