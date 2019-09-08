require 'application_system_test_case'

class ChannelsTest < ApplicationSystemTestCase
  setup do
    @channel = channels(:チャンネル1)
  end

  test 'visiting the index as an user not logged in' do
    visit channels_url
    assert_selector 'h1', text: I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_no_selector 'a', text: I18n.t('helpers.link.new')
    assert_no_selector 'a', text: I18n.t('helpers.link.update_all_snippets')
    assert_no_selector 'a', text: I18n.t('helpers.link.build_all_statistics')
  end

  test 'visiting the index as an user' do
    sign_in user
    visit channels_url
    assert_selector 'h1', text: I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_no_selector 'a', text: I18n.t('helpers.link.new')
    assert_no_selector 'a', text: I18n.t('helpers.link.update_all_snippets')
    assert_no_selector 'a', text: I18n.t('helpers.link.build_all_statistics')
  end

  test 'visiting the index as an admin' do
    sign_in admin
    visit channels_url
    assert_selector 'h1', text: I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_selector 'a', text: I18n.t('helpers.link.new')
    assert_selector 'a', text: I18n.t('helpers.link.update_all_snippets')
    assert_selector 'a', text: I18n.t('helpers.link.build_all_statistics')
  end

  test 'visiting a Channel as an user not logged in' do
    visit channel_url(id: @channel.id)
    assert_no_selector 'a', text: I18n.t('helpers.link.edit')
    assert_no_selector 'a', text: I18n.t('helpers.link.update_snippet')
    assert_no_selector 'a', text: I18n.t('helpers.link.build_statistics')
    assert_no_selector 'a', text: I18n.t('helpers.link.delete')
  end

  test 'visiting a Channel as an user' do
    sign_in user
    visit channel_url(id: @channel.id)
    assert_no_selector 'a', text: I18n.t('helpers.link.edit')
    assert_no_selector 'a', text: I18n.t('helpers.link.update_snippet')
    assert_no_selector 'a', text: I18n.t('helpers.link.build_statistics')
    assert_no_selector 'a', text: I18n.t('helpers.link.delete')
  end

  test 'visiting a Channel as an admin' do
    sign_in admin
    visit channel_url(id: @channel.id)
    assert_selector 'a', text: I18n.t('helpers.link.edit')
    assert_selector 'a', text: I18n.t('helpers.link.update_snippet')
    assert_selector 'a', text: I18n.t('helpers.link.build_statistics')
    assert_selector 'a', text: I18n.t('helpers.link.delete')
  end

  test 'creating a Channel' do
    sign_in admin
    visit channels_url
    click_on I18n.t('helpers.link.new'), match: :first
    page.assert_current_path(new_channel_path)

    channel_id = @channel.channel_id + '_other'
    fill_in Channel.human_attribute_name(:channel_id), with: channel_id
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('helpers.notice.create')
    assert_selector 'h1', text: I18n.t('helpers.title.show', model: Channel.model_name.human)
  end

  test 'updating a Channel' do
    sign_in admin
    visit channels_url
    click_on @channel.title, match: :first
    click_on I18n.t('helpers.link.edit')
    page.assert_current_path(edit_channel_path(id: @channel.id))

    channel_id = @channel.channel_id + '_other'
    fill_in Channel.human_attribute_name(:channel_id), with: channel_id
    click_on I18n.t('helpers.submit.update')

    assert_text I18n.t('helpers.notice.update')
    assert_selector 'h1', text: I18n.t('helpers.title.show', model: Channel.model_name.human)
    page.assert_current_path(channel_path(id: @channel.id))
    assert_equal channel_id, @channel.reload.channel_id
  end

  test 'destroying a Channel' do
    sign_in admin
    visit channels_url
    click_on @channel.title, match: :first
    page.accept_confirm do
      click_on I18n.t('helpers.link.delete')
    end

    assert_text I18n.t('helpers.notice.delete')
  end
end
