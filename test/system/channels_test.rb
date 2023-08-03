# frozen_string_literal: true

require 'application_system_test_case'

class ChannelsTest < ApplicationSystemTestCase
  setup do
    @channel = channels(:channel1)
    100.times do
      build_channel_with_statistics.save!
    end
  end

  test 'visit the index as an user not logged in' do
    visit channels_url
    text = I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_selector 'h1', text: text
    assert_no_button I18n.t('helpers.link.new')
    assert_no_button I18n.t('helpers.link.update_all_snippets')
    assert_no_button I18n.t('helpers.link.build_all_statistics')
  end

  test 'visit the index as an user' do
    sign_in user
    visit channels_url
    text = I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_selector 'h1', text: text
    assert_no_button I18n.t('helpers.link.new')
    assert_no_button I18n.t('helpers.link.update_all_snippets')
    assert_no_button I18n.t('helpers.link.build_all_statistics')
  end

  test 'visit the index as an admin' do
    sign_in admin
    visit channels_url
    text = I18n.t('helpers.title.list', models: Channel.model_name.human.pluralize(I18n.locale))
    assert_selector 'h1', text: text
    assert_button I18n.t('helpers.link.new')
    assert_button I18n.t('helpers.link.update_all_snippets')
    assert_button I18n.t('helpers.link.build_all_statistics')
  end

  test 'get max number of channels when visit the index with per = MAX_PER + 1' do
    visit channels_url(per: Channel::MAX_PER + 1)
    assert_selector('#search-result table tbody tr', count: Channel::MAX_PER)
  end

  test 'get default number of channels when visit the index with per = 0' do
    visit channels_url(per: 0)
    assert_selector('#search-result table tbody tr', count: Channel::DEFAULT_PER)
  end

  test 'get default number of channels when visit the index with per = -1' do
    visit channels_url(per: -1)
    assert_selector('#search-result table tbody tr', count: Channel::DEFAULT_PER)
  end

  test 'visit a channel as an user not logged in' do
    visit channel_url(id: @channel.id)
    assert_no_button I18n.t('helpers.link.update_snippet')
    assert_no_button I18n.t('helpers.link.build_statistics')
    assert_no_button I18n.t('helpers.link.disable')
  end

  test 'visit a channel as an user' do
    sign_in user
    visit channel_url(id: @channel.id)
    assert_no_button I18n.t('helpers.link.update_snippet')
    assert_no_button I18n.t('helpers.link.build_statistics')
    assert_no_button I18n.t('helpers.link.disable')
  end

  test 'visit a channel as an admin' do
    sign_in admin
    visit channel_url(id: @channel.id)
    assert_button I18n.t('helpers.link.update_snippet')
    assert_button I18n.t('helpers.link.build_statistics')
    assert_button I18n.t('helpers.link.disable')
  end

  test 'create a channel' do
    sign_in admin
    visit channels_url
    click_on I18n.t('helpers.link.new'), match: :first
    assert_current_path(new_channel_path)

    channel_id = "#{@channel.channel_id}_other"
    fill_in Channel.human_attribute_name(:channel_id), with: channel_id
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('helpers.notice.create')
    assert_selector 'h1', text: I18n.t('helpers.title.show', model: Channel.model_name.human)

    click_on I18n.t('helpers.link.index')
    assert_current_path(channels_path)
    # The registered channel will be displayed in the index page after BuildStatisticsJob ends.
    # The job ends immediately in the test environment, so it should be displayed.
    assert_selector 'a', text: @channel.reload.title
  end

  test 'create a channel with invalid parameters' do
    sign_in admin
    visit channels_url
    click_on I18n.t('helpers.link.new'), match: :first
    assert_current_path(new_channel_path)

    channel_id = @channel.channel_id
    fill_in Channel.human_attribute_name(:channel_id), with: channel_id
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('errors.messages.taken')
    assert_current_path(new_channel_path)
  end

  test 'enable a channel' do
    assert @channel.update(disabled: true)

    sign_in admin
    visit channels_url
    assert_selector 'a', text: @channel.title
    click_on @channel.title, match: :first
    accept_confirm do
      click_on I18n.t('helpers.link.enable')
    end

    assert_text I18n.t('text.channel.enable.succeeded')
  end

  test 'disable a channel' do
    assert @channel.update(disabled: false)

    sign_in admin
    visit channels_url
    assert_selector 'a', text: @channel.title
    click_on @channel.title, match: :first
    accept_confirm do
      click_on I18n.t('helpers.link.disable')
    end

    assert_text I18n.t('text.channel.disable.succeeded')
  end
end
