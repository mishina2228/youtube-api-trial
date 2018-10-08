require 'test_helper'

class SystemSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_setting = system_settings(:one)
  end

  test "should get index" do
    get system_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_system_setting_url
    assert_response :success
  end

  test "should create system_setting" do
    assert_difference('SystemSetting.count') do
      post system_settings_url, params: { system_setting: { api_key: @system_setting.api_key } }
    end

    assert_redirected_to system_setting_url(SystemSetting.last)
  end

  test "should show system_setting" do
    get system_setting_url(@system_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_setting_url(@system_setting)
    assert_response :success
  end

  test "should update system_setting" do
    patch system_setting_url(@system_setting), params: { system_setting: { api_key: @system_setting.api_key } }
    assert_redirected_to system_setting_url(@system_setting)
  end

  test "should destroy system_setting" do
    assert_difference('SystemSetting.count', -1) do
      delete system_setting_url(@system_setting)
    end

    assert_redirected_to system_settings_url
  end
end
