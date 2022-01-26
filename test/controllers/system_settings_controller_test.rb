require 'test_helper'

class SystemSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_setting = system_setting
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

  test 'should not get new if logged in as an user' do
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

    assert_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: api_key_params
    end
    assert_redirected_to system_setting_url
  end

  test 'should not create system_setting if auth_method is nil' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: api_key_params.deep_merge(system_setting: {auth_method: nil})
    end
    assert_response :success
  end

  test 'should not create system_setting if auth_method is blank' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: api_key_params.deep_merge(system_setting: {auth_method: ''})
    end
    assert_response :success
  end

  test 'should create system_setting if parameter "auth_method" is missing' do
    sign_in admin

    assert_difference -> {SystemSetting.count} do
      params = api_key_params
      params[:system_setting].delete(:auth_method)
      post system_setting_url,
           params: params
    end
    assert_redirected_to system_setting_url
    ss = SystemSetting.find_by(api_key: api_key_params[:system_setting][:api_key])
    assert ss.nothing?
  end

  test 'should not create system_setting if api_key is nil' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: api_key_params.deep_merge(system_setting: {api_key: nil})
    end
    assert_response :success
  end

  test 'should not create system_setting if api_key is blank' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: api_key_params.deep_merge(system_setting: {api_key: ''})
    end
    assert_response :success
  end

  test 'should not create system_setting if parameter "api_key" is missing' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      params = api_key_params
      params[:system_setting].delete(:api_key)
      post system_setting_url,
           params: params
    end
    assert_response :success
  end

  test 'should not create system_setting if client_id is nil' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: oauth2_params.deep_merge(system_setting: {client_id: nil})
    end
    assert_response :success
  end

  test 'should not create system_setting if client_id is blank' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: oauth2_params.deep_merge(system_setting: {client_id: ''})
    end
    assert_response :success
  end

  test 'should not create system_setting if parameter "client_id" is missing' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      params = oauth2_params
      params[:system_setting].delete(:client_id)
      post system_setting_url,
           params: params
    end
    assert_response :success
  end

  test 'should not create system_setting if client_secret is nil' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: oauth2_params.deep_merge(system_setting: {client_secret: nil})
    end
    assert_response :success
  end

  test 'should not create system_setting if client_secret is blank' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      post system_setting_url,
           params: oauth2_params.deep_merge(system_setting: {client_secret: ''})
    end
    assert_response :success
  end

  test 'should not create system_setting if parameter "client_secret" is missing' do
    sign_in admin

    assert_no_difference -> {SystemSetting.count} do
      params = oauth2_params
      params[:system_setting].delete(:client_secret)
      post system_setting_url,
           params: params
    end
    assert_response :success
  end

  test 'should not create system_setting if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      post system_setting_url,
           params: api_key_params
    end
  end

  test 'should not create system_setting unless logged in' do
    assert_raise CanCan::AccessDenied do
      post system_setting_url,
           params: api_key_params
    end
  end

  test 'should show system_setting' do
    sign_in admin

    get system_setting_url
    assert_response :success
  end

  test 'should not show system_setting if logged in as an user' do
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

  test 'should not get edit if logged in as an user' do
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
          params: api_key_params
    assert_redirected_to system_setting_url
  end

  test 'should not update system_setting if auth_method is nil' do
    sign_in admin

    patch system_setting_url,
          params: api_key_params.deep_merge(system_setting: {auth_method: nil})
    assert_response :success
  end

  test 'should not update system_setting if auth_method is blank' do
    sign_in admin

    patch system_setting_url,
          params: api_key_params.deep_merge(system_setting: {auth_method: ''})
    assert_response :success
  end

  test 'should update system_setting if parameter "auth_method" is missing' do
    sign_in admin

    params = api_key_params
    params[:system_setting].delete(:auth_method)
    patch system_setting_url,
          params: params
    assert_redirected_to system_setting_url
  end

  test 'should not update system_setting if api_key is nil' do
    sign_in admin

    patch system_setting_url,
          params: api_key_params.deep_merge(system_setting: {api_key: nil})
    assert_response :success
  end

  test 'should not update system_setting if api_key is blank' do
    sign_in admin

    patch system_setting_url,
          params: api_key_params.deep_merge(system_setting: {api_key: ''})
    assert_response :success
  end

  test 'should update system_setting if parameter "api_key" is missing' do
    sign_in admin

    params = api_key_params
    params[:system_setting].delete(:api_key)
    patch system_setting_url,
          params: params
    assert_redirected_to system_setting_url
  end

  test 'should not update system_setting if client_id is nil' do
    sign_in admin

    patch system_setting_url,
          params: oauth2_params.deep_merge(system_setting: {client_id: nil})
    assert_response :success
  end

  test 'should not update system_setting if client_id is blank' do
    sign_in admin

    patch system_setting_url,
          params: oauth2_params.deep_merge(system_setting: {client_id: ''})
    assert_response :success
  end

  test 'should update system_setting if parameter "client_id" is missing' do
    sign_in admin

    params = oauth2_params
    params[:system_setting].delete(:client_id)
    patch system_setting_url,
          params: params
    assert_redirected_to system_setting_url
  end

  test 'should update system_setting if client_secret is nil' do
    sign_in admin

    patch system_setting_url,
          params: oauth2_params.deep_merge(system_setting: {client_secret: nil})
    assert_redirected_to system_setting_url
  end

  test 'should update system_setting if client_secret is blank' do
    sign_in admin

    patch system_setting_url,
          params: oauth2_params.deep_merge(system_setting: {client_secret: ''})
    assert_redirected_to system_setting_url
  end

  test 'should update system_setting if parameter "client_secret" is missing' do
    sign_in admin

    params = oauth2_params
    params[:system_setting].delete(:client_secret)
    patch system_setting_url,
          params: params
    assert_redirected_to system_setting_url
  end

  test 'should not update system_setting if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      patch system_setting_url,
            params: api_key_params
    end
  end

  test 'should not update system_setting unless not logged in' do
    assert_raise CanCan::AccessDenied do
      patch system_setting_url,
            params: api_key_params
    end
  end

  test 'should get oauth2 auth url' do
    assert system_setting.update(auth_method: :oauth2)
    assert system_setting.oauth2?
    sign_in admin

    put oauth2_authorize_system_setting_url, xhr: true

    assert_response :success
  end

  test 'should reload if auth method is not oauth2' do
    assert_not system_setting.oauth2?
    sign_in admin

    put oauth2_authorize_system_setting_url, xhr: true

    assert_response :success
    assert_equal I18n.t('helpers.notice.oauth2_required'), flash[:notice]
  end

  test 'should redirect to system setting if auth method is oauth2' do
    assert system_setting.update(auth_method: :oauth2)
    assert system_setting.oauth2?
    sign_in admin

    put oauth2_store_credential_system_setting_path,
        params: {system_setting: {code: 'dummy'}}

    assert_response :redirect
    assert_redirected_to system_setting_url
    assert_equal I18n.t('helpers.notice.oauth2_credential_stored'), flash[:notice]
  end

  test 'should redirect to system setting if auth method is not oauth2' do
    assert_not system_setting.oauth2?
    sign_in admin

    put oauth2_store_credential_system_setting_path,
        params: {system_setting: {code: 'dummy'}}

    assert_response :redirect
    assert_redirected_to system_setting_url
    assert_equal I18n.t('helpers.notice.oauth2_required'), flash[:notice]
  end

  test 'should not get oauth2 auth url if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put oauth2_authorize_system_setting_url
    end
  end

  test 'should not get oauth2 auth url unless not logged in' do
    assert_raise CanCan::AccessDenied do
      put oauth2_authorize_system_setting_url
    end
  end

  test 'should not store oauth2 credential if logged in as an user' do
    sign_in user

    assert_raise CanCan::AccessDenied do
      put oauth2_store_credential_system_setting_url
    end
  end

  test 'should not store oauth2 credential unless not logged in' do
    assert_raise CanCan::AccessDenied do
      put oauth2_store_credential_system_setting_url
    end
  end

  def api_key_params
    {
      system_setting: {
        auth_method: :api_key,
        api_key: "#{@system_setting.api_key}_new"
      }
    }
  end

  def oauth2_params
    {
      system_setting: {
        auth_method: :oauth2,
        client_id: "#{@system_setting.client_id}_new",
        client_secret: "#{@system_setting.client_secret}_new"
      }
    }
  end
end
