require 'test_helper'

module Channels
  class TagsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @channel = channels(:channel1)
    end

    test 'should edit tags' do
      sign_in admin

      get edit_channel_tags_path(channel_id: @channel.id)
      assert_response :success
    end

    test 'should not edit tags if logged in as an user' do
      sign_in user

      assert_raise ActionController::RoutingError do
        get edit_channel_tags_path(channel_id: @channel.id)
      end
    end

    test 'should not edit tags unless logged in' do
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
          }

      assert_response :redirect
      assert_equal I18n.t('text.channel.update_tags.error'), flash[:alert]

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
          }

      assert_response :redirect
      assert_equal I18n.t('text.channel.update_tags.error'), flash[:alert]

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
          }

      assert_response :redirect
      assert_equal I18n.t('text.channel.update_tags.success'), flash[:notice]

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
          }

      assert_response :redirect
      assert_equal I18n.t('text.channel.update_tags.error'), flash[:alert]

      assert_equal %w[tag1], @channel.reload.tag_list.sort
    end

    test 'should not update tags if logged in as an user' do
      sign_in user

      assert_raise ActionController::RoutingError do
        put channel_tags_path(channel_id: @channel.id)
      end
    end

    test 'should not update tags unless logged in' do
      assert_raise ActionController::RoutingError do
        put channel_tags_path(channel_id: @channel.id)
      end
    end
  end
end
