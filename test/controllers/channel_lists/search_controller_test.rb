# frozen_string_literal: true

require 'test_helper'

module ChannelLists
  class SearchControllerTest < ActionDispatch::IntegrationTest
    test 'should get index as html' do
      sign_in admin

      get channel_lists_search_index_url
      assert_response :success
    end

    test 'should get index as html if query is passed' do
      sign_in admin

      get channel_lists_search_index_url, params: {search_channel_list_condition: {query: 'title'}}
      assert_response :success
    end

    test 'should not get index if logged in as an user' do
      sign_in user

      get channel_lists_search_index_url
      assert_response :not_found
    end

    test 'should not get index unless logged in' do
      get channel_lists_search_index_url
      assert_response :not_found
    end

    test 'should create a channel' do
      sign_in admin

      assert_difference -> {Channel.count} do
        post channel_lists_search_index_url, params: channel_params, headers: {'Turbo-Frame' => 'foo'}
      end

      assert_response :success
    end

    test 'should not create a channel if parameters are invalid' do
      sign_in admin

      assert_no_difference -> {Channel.count} do
        post channel_lists_search_index_url,
             params: channel_params.tap {|h| h[:channel][:channel_id] = nil},
             headers: {'Turbo-Frame' => 'foo'}
      end

      assert_response :unprocessable_entity
    end

    test 'should redirect to index if not turbo frame' do
      sign_in admin

      assert_no_difference -> {Channel.count} do
        post channel_lists_search_index_url, params: channel_params
      end

      assert_response :redirect
      assert_redirected_to channel_lists_search_index_url
    end

    def channel_params
      {
        channel: {
          channel_id: "channel_id#{Time.current.usec}",
          thumbnail_url: 'https://example.com/thumbnail/1',
          title: 'Channel1 100% POWER',
          description: 'description1'
        }
      }
    end
  end
end
