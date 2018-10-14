require 'test_helper'

class SystemSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_setting = system_settings(:システム設定)
  end

  test 'should get index' do
    assert ss = SystemSetting.first
    get system_settings_url
    assert_response :redirect
    assert_redirected_to system_setting_url(id: ss)

    SystemSetting.destroy_all
    get system_settings_url
    assert_response :redirect
    assert_redirected_to new_system_setting_url
  end

  test 'should get new' do
    assert ss = SystemSetting.first
    get new_system_setting_url
    assert_response :redirect
    assert_redirected_to system_setting_url(id: ss)

    SystemSetting.destroy_all
    get new_system_setting_url
    assert_response :success
  end

  test 'should create system_setting' do
    assert_difference('SystemSetting.count') do
      post system_settings_url,
           params: {
             system_setting: {
               api_key: @system_setting.api_key
             }
           }
    end

    assert_redirected_to system_setting_url(SystemSetting.last)
  end

  test 'should show system_setting' do
    get system_setting_url(id: @system_setting)
    assert_response :success
  end

  test 'should get edit' do
    get edit_system_setting_url(id: @system_setting)
    assert_response :success
  end

  test 'should update system_setting' do
    patch system_setting_url(id: @system_setting), params: {system_setting: {api_key: @system_setting.api_key}}
    assert_redirected_to system_setting_url(@system_setting)
  end
end
