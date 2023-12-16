# frozen_string_literal: true

require 'test_helper'

module Channels
  class StatisticsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @channel = channels(:channel1)
    end

    test 'should get index' do
      get channel_statistics_path(channel_id: @channel.id), headers: {'Turbo-Frame' => 'foo'}
      assert_response :success
    end

    test 'should redirect to channel_path if not turbo frame' do
      get channel_statistics_path(channel_id: @channel.id)
      assert_response :redirect
      assert_redirected_to channel_path(@channel)
    end
  end
end
