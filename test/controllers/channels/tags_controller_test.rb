require 'test_helper'

class Channels::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:channel1)
  end

  test 'should edit tags' do
    sign_in admin

    get edit_channel_tags_path(channel_id: @channel.id), xhr: true
    assert_response :success
  end

  test 'should redirect to channel page when get edit_tags without using ajax' do
    sign_in admin

    get edit_channel_tags_path(channel_id: @channel.id)
    assert_response :redirect
    assert_redirected_to channel_url(@channel)
  end

  test 'should not edit tags if logged in as an user' do
    sign_in user

    assert_raise ActionController::RoutingError do
      get edit_channel_tags_path(channel_id: @channel.id), xhr: true
    end
    assert_raise ActionController::RoutingError do
      get edit_channel_tags_path(channel_id: @channel.id)
    end
  end

  test 'should not edit tags unless logged in' do
    assert_raise ActionController::RoutingError do
      get edit_channel_tags_path(channel_id: @channel.id), xhr: true
    end
    assert_raise ActionController::RoutingError do
      get edit_channel_tags_path(channel_id: @channel.id)
    end
  end

  test 'should not update tags with passing tag_list as an array' do
    assert_includes @channel.tag_list, 'tag1'
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: %w[tag2 tag3]
          }
        }, xhr: true

    assert_response :success

    assert_equal %w[tag1], @channel.reload.tag_list.sort
  end

  test 'should not update tags with passing tag_list as a comma-separated string' do
    assert_includes @channel.tag_list, 'tag1'
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: 'tag2,tag3'
          }
        }, xhr: true

    assert_response :success

    assert_equal %w[tag1], @channel.reload.tag_list.sort
  end

  test 'should update tags with passing tag_list as a json string' do
    assert_includes @channel.tag_list, 'tag1'
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: [{value: 'tag2'}, {value: 'tag3'}].to_json
          }
        }, xhr: true

    assert_response :success

    assert_equal %w[tag2 tag3], @channel.reload.tag_list.sort
  end

  test 'should not update tags if a record is invalid' do
    assert_includes @channel.tag_list, 'tag1'
    assert @channel.update_columns(channel_id: '')
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: [{value: 'tag2'}, {value: 'tag3'}].to_json
          }
        }, xhr: true

    assert_response :success
    assert_includes body, I18n.t('text.channel.update_tags.error')

    assert_equal %w[tag1], @channel.reload.tag_list.sort
  end

  test 'should update tags without using ajax' do
    assert_includes @channel.tag_list, 'tag1'
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: [{value: 'tag2'}, {value: 'tag3'}].to_json
          }
        }

    assert_response :redirect
    assert_redirected_to channel_url(@channel)

    assert_equal %w[tag2 tag3], @channel.reload.tag_list.sort
  end

  test 'should not update tags if a record is invalid without using ajax' do
    assert_includes @channel.tag_list, 'tag1'
    assert @channel.update_columns(channel_id: '')
    sign_in admin

    put channel_tags_path(channel_id: @channel.id),
        params: {
          channel: {
            tag_list: [{value: 'tag2'}, {value: 'tag3'}].to_json
          }
        }

    assert_response :redirect
    assert_redirected_to channel_url(@channel)

    assert_equal %w[tag1], @channel.reload.tag_list.sort
  end

  test 'should not update tags if logged in as an user' do
    sign_in user

    assert_raise ActionController::RoutingError do
      put channel_tags_path(channel_id: @channel.id), xhr: true
    end
    assert_raise ActionController::RoutingError do
      put channel_tags_path(channel_id: @channel.id)
    end
  end

  test 'should not update tags unless logged in' do
    assert_raise ActionController::RoutingError do
      put channel_tags_path(channel_id: @channel.id), xhr: true
    end
    assert_raise ActionController::RoutingError do
      put channel_tags_path(channel_id: @channel.id)
    end
  end
end
