# frozen_string_literal: true

require 'application_system_test_case'

module ChannelLists
  class SubscriptionsTest < ApplicationSystemTestCase
    test 'list subscribed channels' do
      system_setting.update!(auth_method: :oauth2)
      assert system_setting.oauth2?

      sign_in admin
      visit channels_url
      assert_no_selector('div.loader-bg') # wait until loaders are gone
      click_on I18n.t('helpers.link.create_from_subscription')
      assert_current_path(channel_lists_subscriptions_url)

      within('#search-result') do
        assert_text I18n.t('text.subscription.total_results')

        assert_text 'dummy channel 0'
        assert_no_text 'dummy channel 11'
      end

      within('#search-result-pagination') do
        assert_no_link '‹'
        assert_link '›'

        click_on '›'
      end

      within('#search-result') do
        assert_text I18n.t('text.subscription.total_results')

        assert_no_text 'dummy channel 0'
        assert_text 'dummy channel 11'
      end

      within('#search-result-pagination') do
        assert_link '‹'
        assert_link '›'
      end
    end

    test 'specify page size' do
      system_setting.update!(auth_method: :oauth2)
      assert system_setting.oauth2?

      sign_in admin
      visit channel_lists_subscriptions_url

      select 20, from: ::Search::ChannelListCondition.human_attribute_name(:per)
      click_on I18n.t('helpers.submit.show')

      within('#search-result') do
        assert_selector('.container.kinda-table .row', count: 20)
      end
    end

    test 'reset form fields' do
      system_setting.update!(auth_method: :oauth2)
      assert system_setting.oauth2?

      sign_in admin
      visit channel_lists_subscriptions_url

      select 20, from: ::Search::ChannelListCondition.human_attribute_name(:per)
      click_on I18n.t('helpers.button.reset')

      assert_select ::Search::ChannelListCondition.human_attribute_name(:per), selected: '5'
    end

    test 'create channels from subscribed channels' do
      assert_not Channel.exists?(channel_id: 'dummy_channel_id_0')
      system_setting.update!(auth_method: :oauth2)
      assert system_setting.oauth2?

      sign_in admin
      visit channel_lists_subscriptions_url

      within('#search-result') do
        assert_text 'dummy channel 0'
        within('turbo-frame#dummy_channel_id_0') do
          click_button I18n.t('helpers.submit.create_channel')
          assert_text I18n.t('helpers.link.channel_created')
        end
      end
      assert Channel.exists?(channel_id: 'dummy_channel_id_0')
    end

    test 'cannot create channels that has already been created' do
      Channel.create!(valid_channel_params.merge(channel_id: 'dummy_channel_id_1'))
      system_setting.update!(auth_method: :oauth2)
      assert system_setting.oauth2?

      sign_in admin
      visit channel_lists_subscriptions_url

      within('#search-result turbo-frame#dummy_channel_id_1') do
        assert_button I18n.t('helpers.link.channel_created'), disabled: true
      end
    end
  end
end
