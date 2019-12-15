require 'application_system_test_case'

class SystemSettingsTest < ApplicationSystemTestCase
  setup do
    @system_setting = system_settings(:system_setting)
  end

  test 'visiting a System setting as an user not logged in' do
    visit root_path
    assert_no_selector 'a', text: SystemSetting.model_name.human
  end

  test 'visiting a System setting as an user' do
    sign_in user
    visit root_path
    assert_no_selector 'a', text: SystemSetting.model_name.human
  end

  test 'visiting a System setting as an admin' do
    sign_in admin
    visit root_path
    assert_selector 'a', text: SystemSetting.model_name.human
    click_on SystemSetting.model_name.human

    assert_current_path(system_setting_path)
    assert_selector 'h1', text: I18n.t('helpers.title.show', model: SystemSetting.model_name.human)
  end

  test 'creating a System setting api_key' do
    SystemSetting.destroy_all

    sign_in admin
    visit system_setting_path
    assert_current_path(new_system_setting_path)

    choose SystemSetting.auth_methods_i18n['api_key']
    fill_in SystemSetting.human_attribute_name(:api_key), with: @system_setting.api_key
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('helpers.notice.create')
    assert_current_path(system_setting_path)
  end

  test 'creating a System setting oauth2' do
    SystemSetting.destroy_all

    sign_in admin
    visit system_setting_path
    assert_current_path(new_system_setting_path)

    choose SystemSetting.auth_methods_i18n['oauth2']
    fill_in SystemSetting.human_attribute_name(:client_id), with: @system_setting.client_id
    fill_in SystemSetting.human_attribute_name(:client_secret), with: @system_setting.client_secret
    click_on I18n.t('helpers.submit.create')

    assert_text I18n.t('helpers.notice.create')
    assert_current_path(system_setting_path)
  end

  test 'updating a System setting' do
    sign_in admin
    visit system_setting_path
    click_on I18n.t('helpers.link.edit')

    assert_current_path(edit_system_setting_path)
    after_api_key = @system_setting.api_key + '_after'
    fill_in SystemSetting.human_attribute_name(:api_key), with: after_api_key
    click_on I18n.t('helpers.submit.update')

    assert_text I18n.t('helpers.notice.update')
    assert_current_path(system_setting_path)
    assert_equal after_api_key, @system_setting.reload.api_key
  end
end
