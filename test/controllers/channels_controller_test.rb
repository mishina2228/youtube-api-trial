# frozen_string_literal: true

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

    get new_channel_url
    assert_response :not_found
  end

  test 'should not get new unless logged in' do
    get new_channel_url
    assert_response :not_found
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

    post channels_url,
         params: {
           channel: {
             channel_id: @channel.channel_id + Time.current.usec.to_s
           }
         }
    assert_response :not_found
  end

  test 'should not create a channel unless logged in' do
    post channels_url,
         params: {
           channel: {
             channel_id: @channel.channel_id + Time.current.usec.to_s
           }
         }
    assert_response :not_found
  end

  test 'should show a channel' do
    get channel_url(id: @channel)
    assert_response :success
  end

  test 'should build statistics' do
    sign_in admin

    put build_statistics_channel_url(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
  end

  test 'should build statistics and results should be returned in json format' do
    sign_in admin

    put build_statistics_channel_url(id: @channel), as: :json

    assert_response :success
    assert_equal I18n.t('text.channel.build_statistics.start'), JSON.parse(body)['message']
  end

  test 'should not build statistics if logged in as an user' do
    sign_in user

    put build_statistics_channel_url(id: @channel)
    assert_response :not_found
  end

  test 'should not build statistics unless logged in' do
    put build_statistics_channel_url(id: @channel)
    assert_response :not_found
  end

  test 'should build all statistics' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    sign_in admin

    put build_all_statistics_channels_url

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should build all statistics and results should be returned in json format' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    sign_in admin

    put build_all_statistics_channels_url, as: :json

    assert_response :success
    assert_equal I18n.t('text.channel.build_all_statistics.start'), JSON.parse(body)['message']
  end

  test 'should not build all statistics if logged in as an user' do
    sign_in user

    put build_all_statistics_channels_path
    assert_response :not_found
  end

  test 'should not build all statistics unless logged in' do
    put build_all_statistics_channels_path
    assert_response :not_found
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

  test 'should update a snippet and results should be returned in json format' do
    sign_in admin

    put update_snippet_channel_path(id: @channel), as: :json

    assert_response :success
    assert_equal I18n.t('text.channel.update_snippet.start'), JSON.parse(body)['message']
  end

  test 'should not update a snippet if logged in as an user' do
    sign_in user

    put update_snippet_channel_path(id: @channel)
    assert_response :not_found
  end

  test 'should not update a snippet unless logged in' do
    put update_snippet_channel_path(id: @channel)
    assert_response :not_found
  end

  test 'should update all snippets' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)
    sign_in admin

    put update_all_snippets_channels_path

    assert_response :redirect
    assert_redirected_to channels_url
  end

  test 'should update all snippets and results should be returned in json format' do
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)
    sign_in admin

    put update_all_snippets_channels_path, as: :json

    assert_response :success
    assert_equal I18n.t('text.channel.update_all_snippets.start'), JSON.parse(body)['message']
  end

  test 'should not update all snippets if logged in as an user' do
    sign_in user

    put update_all_snippets_channels_path
    assert_response :not_found
  end

  test 'should not update all snippets unless logged in' do
    put update_all_snippets_channels_path
    assert_response :not_found
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

  test 'should re-enable a channel and results should be returned in json format' do
    assert @channel.update(disabled: true)
    sign_in admin

    put enable_channel_path(id: @channel), as: :json

    assert_response :success
    assert @channel.reload.enabled?
    assert_equal I18n.t('text.channel.enable.succeeded'), JSON.parse(body)['message']
  end

  test 'should not re-enable a channel if a record is invalid' do
    assert @channel.update_columns(disabled: true, channel_id: '')
    sign_in admin

    put enable_channel_path(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
    assert @channel.reload.disabled?
  end

  test 'should not re-enable a channel and results should be returned in json format if a record is invalid' do
    assert @channel.update_columns(disabled: true, channel_id: '')
    sign_in admin

    put enable_channel_path(id: @channel), as: :json

    assert_response :success
    assert @channel.reload.disabled?
    assert_equal I18n.t('text.channel.enable.failed'), JSON.parse(body)['message']
  end

  test 'should not re-enable a channel if logged in as an user' do
    assert @channel.update(disabled: true)
    sign_in user

    put enable_channel_path(id: @channel)
    assert_response :not_found
    assert @channel.reload.disabled?
  end

  test 'should not re-enable a channel unless logged in' do
    assert @channel.update(disabled: true)

    put enable_channel_path(id: @channel)
    assert_response :not_found
    assert @channel.reload.disabled?
  end

  test 'should disable a channel' do
    assert @channel.update(disabled: false)
    sign_in admin

    put disable_channel_path(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
    assert @channel.reload.disabled?
  end

  test 'should disable a channel and results should be returned in json format' do
    assert @channel.update(disabled: false)
    sign_in admin

    put disable_channel_path(id: @channel), as: :json

    assert_response :success
    assert @channel.reload.disabled?
    assert_equal I18n.t('text.channel.disable.succeeded'), JSON.parse(body)['message']
  end

  test 'should not disable a channel if a record is invalid' do
    assert @channel.update_columns(disabled: false, channel_id: '')
    sign_in admin

    put disable_channel_path(id: @channel)

    assert_response :redirect
    assert_redirected_to channel_url(@channel)
    assert @channel.reload.enabled?
  end

  test 'should not disable a channel and results should be returned in json format if a record is invalid' do
    assert @channel.update_columns(disabled: false, channel_id: '')
    sign_in admin

    put disable_channel_path(id: @channel), as: :json

    assert_response :success
    assert @channel.reload.enabled?
    assert_equal I18n.t('text.channel.disable.failed'), JSON.parse(body)['message']
  end

  test 'should not disable a channel if logged in as an user' do
    assert @channel.update(disabled: false)
    sign_in user

    put disable_channel_path(id: @channel)
    assert_response :not_found
    assert @channel.reload.enabled?
  end

  test 'should not disable a channel unless logged in' do
    assert @channel.update(disabled: false)

    put disable_channel_path(id: @channel)
    assert_response :not_found
    assert @channel.reload.enabled?
  end
end
