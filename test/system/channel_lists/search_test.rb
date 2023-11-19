# frozen_string_literal: true

require 'application_system_test_case'

module ChannelLists
  class SearchTest < ApplicationSystemTestCase
    test 'search channels by query' do
      sign_in admin
      visit channels_url
      click_on I18n.t('helpers.link.create_from_search')
      assert_current_path(channel_lists_search_index_url)

      fill_in ::Search::ChannelListCondition.human_attribute_name(:query), with: 'FOO'
      click_on I18n.t('helpers.submit.search')

      within('#search-result') do
        assert_text I18n.t('text.search.total_results')

        assert_text 'FOO'
        assert_text 'dummy channel 0'
        assert_no_text 'dummy channel 11'
      end

      within('#search-result-pagination') do
        assert_no_link '‹'
        assert_link '›'

        click_on '›'
      end

      within('#search-result') do
        assert_text I18n.t('text.search.total_results')

        assert_text 'FOO'
        assert_no_text 'dummy channel 0'
        assert_text 'dummy channel 11'
      end

      within('#search-result-pagination') do
        assert_link '‹'
        assert_link '›'
      end
    end

    test 'specify page size' do
      sign_in admin
      visit channel_lists_search_index_url

      fill_in ::Search::ChannelListCondition.human_attribute_name(:query), with: 'FOO'
      select 20, from: ::Search::ChannelListCondition.human_attribute_name(:per)
      click_on I18n.t('helpers.submit.search')

      within('#search-result') do
        assert_selector('.container.kinda-table .row', count: 20)
      end
    end

    test 'reset form fields' do
      sign_in admin
      visit channel_lists_search_index_url

      fill_in ::Search::ChannelListCondition.human_attribute_name(:query), with: 'FOO'
      select 20, from: ::Search::ChannelListCondition.human_attribute_name(:per)
      click_on I18n.t('helpers.button.reset')

      assert_field ::Search::ChannelListCondition.human_attribute_name(:query), with: ''
      assert_select ::Search::ChannelListCondition.human_attribute_name(:per), selected: '5'
    end

    test 'create channels from subscribed channels' do
      assert_not Channel.exists?(channel_id: 'dummy_channel_id_0')
      sign_in admin
      visit channel_lists_search_index_url

      fill_in ::Search::ChannelListCondition.human_attribute_name(:query), with: 'FOO'
      click_on I18n.t('helpers.submit.search')

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
      sign_in admin
      visit channel_lists_search_index_url

      fill_in ::Search::ChannelListCondition.human_attribute_name(:query), with: 'FOO'
      click_on I18n.t('helpers.submit.search')

      within('#search-result turbo-frame#dummy_channel_id_1') do
        assert_button I18n.t('helpers.link.channel_created'), disabled: true
      end
    end
  end
end
