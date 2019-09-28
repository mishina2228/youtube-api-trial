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

  test 'should not get new if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get new_channel_url
    end
  end

  test 'should not get new unless logged in' do
    assert_raise CanCan::AccessDenied do
      get new_channel_url
    end
  end

  test 'should create channel' do
    sign_in admin

    channel_id = @channel.channel_id + Time.current.usec.to_s
    assert_difference -> {Channel.count} do
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

  test 'should not create channel if logged in as an user' do
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

  test 'should not create channel unless logged in' do
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

  test 'should destroy channel' do
    sign_in admin

    assert_difference -> {Channel.count}, -1 do
      delete channel_url(id: @channel)
    end

    assert_redirected_to channels_url
  end

  test 'should not destroy channel if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      delete channel_url(id: @channel)
    end
  end

  test 'should not destroy channel unless logged in' do
    assert_raise CanCan::AccessDenied do
      delete channel_url(id: @channel)
    end
  end

  test 'should build statistics' do
    sign_in admin

    put build_statistics_channel_url(id: @channel)
    assert_redirected_to channel_url(@channel)
  end

  test 'should not build statistics if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put build_statistics_channel_url(id: @channel)
    end
  end

  test 'should not build statistics unless logged in' do
    assert_raise CanCan::AccessDenied do
      put build_statistics_channel_url(id: @channel)
    end
  end

  test 'should build all statistics' do
    [channels(:エラーチャンネル), channels(:存在しないチャンネル)].each(&:destroy)

    sign_in admin

    put build_all_statistics_channels_url
    assert_redirected_to channels_url
  end

  test 'should not build all statistics if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put build_all_statistics_channels_path
    end
  end

  test 'should not build all statistics unless logged in' do
    assert_raise CanCan::AccessDenied do
      put build_all_statistics_channels_path
    end
  end

  test 'should redirect to index when trying to build all statistics if no channel' do
    Channel.delete_all

    sign_in admin
    put build_all_statistics_channels_url
    assert_redirected_to channels_url
  end

  test 'should update snippet' do
    sign_in admin

    put update_snippet_channel_path(id: @channel)
    assert_redirected_to channel_url(@channel)
  end

  test 'should not update snippet if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put update_snippet_channel_path(id: @channel)
    end
  end

  test 'should not update snippet unless logged in' do
    assert_raise CanCan::AccessDenied do
      put update_snippet_channel_path(id: @channel)
    end
  end

  test 'should update all snippets' do
    [channels(:エラーチャンネル), channels(:存在しないチャンネル)].each(&:destroy)

    sign_in admin

    put update_all_snippets_channels_path
    assert_redirected_to channels_url
  end

  test 'should not update all snippets if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put update_all_snippets_channels_path
    end
  end

  test 'should not update all snippets unless logged in' do
    assert_raise CanCan::AccessDenied do
      put update_all_snippets_channels_path
    end
  end

  test 'should redirect to index when trying to update all snippets if no channel' do
    Channel.delete_all

    sign_in admin

    put update_all_snippets_channels_path
    assert_redirected_to channels_url
  end
end
