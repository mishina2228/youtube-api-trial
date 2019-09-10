require 'test_helper'

class SystemSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_setting = system_settings(:システム設定)
  end

  test 'should get new' do
    sign_in admin

    assert SystemSetting.first
    get new_system_setting_url
    assert_response :redirect
    assert_redirected_to system_setting_url

    SystemSetting.destroy_all
    get new_system_setting_url
    assert_response :success
  end

  test 'should not get new' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get new_system_setting_url
    end
  end

  test 'should not get new unless logged in' do
    assert_raise CanCan::AccessDenied do
      get new_system_setting_url
    end
  end

  test 'should create system_setting' do
    sign_in admin

    assert_difference('SystemSetting.count') do
      post system_setting_url,
           params: {
             system_setting: {
               api_key: @system_setting.api_key
             }
           }
    end
    assert_redirected_to system_setting_url
  end

  test 'should not create system_setting' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      post system_setting_url,
           params: {
             system_setting: {
               api_key: @system_setting.api_key
             }
           }
    end
  end

  test 'should not create system_setting unless logged in' do
    assert_raise CanCan::AccessDenied do
      post system_setting_url,
           params: {
             system_setting: {
               api_key: @system_setting.api_key
             }
           }
    end
  end

  test 'should show system_setting' do
    sign_in admin

    get system_setting_url
    assert_response :success
  end

  test 'should not show system_setting' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get system_setting_url
    end
  end

  test 'should not show system_setting unless not logged in' do
    assert_raise CanCan::AccessDenied do
      get system_setting_url
    end
  end

  test 'should get edit' do
    sign_in admin

    get edit_system_setting_url
    assert_response :success
  end

  test 'should not get edit' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      get edit_system_setting_url
    end
  end

  test 'should not get edit unless not logged in' do
    assert_raise CanCan::AccessDenied do
      get edit_system_setting_url
    end
  end

  test 'should update system_setting' do
    sign_in admin

    patch system_setting_url,
          params: {
            system_setting: {
              api_key: @system_setting.api_key
            }
          }
    assert_redirected_to system_setting_url
  end

  test 'should not update system_setting' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      patch system_setting_url,
            params: {
              system_setting: {
                api_key: @system_setting.api_key
              }
            }
    end
  end

  test 'should not update system_setting unless not logged in' do
    assert_raise CanCan::AccessDenied do
      patch system_setting_url,
            params: {
              system_setting: {
                api_key: @system_setting.api_key
              }
            }
    end
  end
end
