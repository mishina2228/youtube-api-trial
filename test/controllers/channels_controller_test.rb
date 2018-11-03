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
    sign_in admin

    get new_channel_url
    assert_response :success
  end

  test 'should not get new' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get new_channel_url
    end
  end

  test 'should create channel' do
    sign_in admin

    channel_id = @channel.channel_id + Time.current.usec.to_s
    assert_difference('Channel.count') do
      post channels_url,
           params: {
             channel: {
               channel_id: channel_id
             }
           }
    end

    assert_redirected_to channel_url(Channel.last)
    assert_equal channel_id, Channel.last.channel_id
  end

  test 'should not create channel' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      post channels_url,
           params: {
             channel: {
               channel_id: @channel.channel_id + Time.current.usec.to_s
             }
           }
    end
  end

  test 'should show channel' do
    get channel_url(id: @channel)
    assert_response :success
  end

  test 'should get edit' do
    sign_in admin

    get edit_channel_url(id: @channel)
    assert_response :success
  end

  test 'should not get edit' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get edit_channel_url(id: @channel)
    end
  end

  test 'should update channel' do
    sign_in admin

    patch channel_url(id: @channel),
          params: {
            channel: {
              channel_id: @channel.channel_id
            }
          }
    assert_redirected_to channel_url(@channel)
  end

  test 'should not update channel' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      patch channel_url(id: @channel),
            params: {
              channel: {
                channel_id: @channel.channel_id
              }
            }
    end
  end

  test 'should destroy channel' do
    sign_in admin

    assert_difference('Channel.count', -1) do
      delete channel_url(id: @channel)
    end

    assert_redirected_to channels_url
  end

  test 'should not destroy channel' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      delete channel_url(id: @channel)
    end
  end
end
