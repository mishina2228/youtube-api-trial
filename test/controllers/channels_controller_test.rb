require 'test_helper'

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:チャンネル1)
  end

  test 'should get index' do
    get channels_url
    assert_response :success
  end

  test 'should get new' do
    get new_channel_url
    assert_response :success
  end

  test 'should create channel' do
    assert_difference('Channel.count') do
      post channels_url,
           params: {
             channel: {
               channel_id: @channel.channel_id + Time.current.usec.to_s,
               description: @channel.description,
               thumbnail_url: @channel.thumbnail_url,
               title: @channel.title
             }
           }
    end

    assert_redirected_to channel_url(Channel.last)
  end

  test 'should show channel' do
    get channel_url(id: @channel)
    assert_response :success
  end

  test 'should get edit' do
    get edit_channel_url(id: @channel)
    assert_response :success
  end

  test 'should update channel' do
    patch channel_url(id: @channel), params: {channel: {channel_id: @channel.channel_id, description: @channel.description, thumbnail_url: @channel.thumbnail_url, title: @channel.title}}
    assert_redirected_to channel_url(@channel)
  end

  test 'should destroy channel' do
    assert_difference('Channel.count', -1) do
      delete channel_url(id: @channel)
    end

    assert_redirected_to channels_url
  end
end
