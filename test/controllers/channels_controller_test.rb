require 'test_helper'

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:channel1)
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

  test 'should create a channel' do
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

    assert_response :redirect
    assert_redirected_to channel_url(Channel.last)
    assert_equal channel_id, Channel.last.channel_id
  end

  test 'should not create a channel if parameters are invalid' do
    sign_in admin

    assert_no_difference -> {Channel.count} do
      post channels_url,
           params: {
             channel: {
               channel_id: nil
             }
           }
    end

    assert_response :success
  end

  test 'should not create a channel if logged in as an user' do
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

  test 'should not create a channel unless logged in' do
    assert_raise CanCan::AccessDenied do
      post channels_url,
           params: {
             channel: {
               channel_id: @channel.channel_id + Time.current.usec.to_s
             }
           }
    end
  end

  test 'should show a channel' do
    get channel_url(id: @channel)
    assert_response :success
  end

  test 'should destroy a channel' do
    sign_in admin

    assert_difference -> {Channel.count}, -1 do
      delete channel_url(id: @channel)
    end

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should not destroy a channel if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      delete channel_url(id: @channel)
    end
  end

  test 'should not destroy a channel unless logged in' do
    assert_raise CanCan::AccessDenied do
      delete channel_url(id: @channel)
    end
  end

  test 'should build statistics' do
    sign_in admin

    put build_statistics_channel_url(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
  end

  test 'should build statistics via ajax' do
    sign_in admin

    put build_statistics_channel_url(id: @channel), xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.build_statistics.start')
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
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    sign_in admin

    put build_all_statistics_channels_url

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should build all statistics via ajax' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    sign_in admin

    put build_all_statistics_channels_url, xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.build_all_statistics.start')
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

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should update a snippet' do
    sign_in admin

    put update_snippet_channel_path(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
  end

  test 'should update a snippet via ajax' do
    sign_in admin

    put update_snippet_channel_path(id: @channel), xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.update_snippet.start')
  end

  test 'should not update a snippet if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put update_snippet_channel_path(id: @channel)
    end
  end

  test 'should not update a snippet unless logged in' do
    assert_raise CanCan::AccessDenied do
      put update_snippet_channel_path(id: @channel)
    end
  end

  test 'should update all snippets' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)
    sign_in admin

    put update_all_snippets_channels_path

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should update all snippets via ajax' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)
    sign_in admin

    put update_all_snippets_channels_path, xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.update_all_snippets.start')
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

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should re-enable a channel' do
    assert @channel.update(disabled: true)
    sign_in admin

    put enable_channel_path(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
    assert @channel.reload.enabled?
  end

  test 'should re-enable a channel via ajax' do
    assert @channel.update(disabled: true)
    sign_in admin

    put enable_channel_path(id: @channel), xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.enable.succeeded')
  end

  test 'should not re-enable a channel via ajax if a record is invalid' do
    assert @channel.update_columns(disabled: true, channel_id: '')
    sign_in admin

    put enable_channel_path(id: @channel), xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.enable.failed')
  end

  test 'should not re-enable a channel if logged in as an user' do
    assert @channel.update(disabled: true)
    sign_in user

    assert_raise CanCan::AccessDenied do
      put enable_channel_path(id: @channel)
    end
    assert @channel.reload.disabled?
  end

  test 'should not re-enable a channel unless logged in' do
    assert @channel.update(disabled: true)

    assert_raise CanCan::AccessDenied do
      put enable_channel_path(id: @channel)
    end
    assert @channel.reload.disabled?
  end
end
