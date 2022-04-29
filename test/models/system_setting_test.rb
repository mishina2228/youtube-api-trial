# frozen_string_literal: true

require 'test_helper'
require 'googleauth/user_refresh'

class SystemSettingTest < ActiveSupport::TestCase
  test 'validation' do
    ss = SystemSetting.new(valid_params)
    assert ss.valid?

    ss = SystemSetting.new(valid_params.merge(auth_method: nil))
    assert ss.invalid?
  end

  test 'api_key should not be blank when auth_method is api_key' do
    ss = SystemSetting.new(valid_params)
    assert ss.api_key?
    assert ss.api_key.present?
    assert ss.valid?

    assert SystemSetting.new(valid_params.merge(api_key: nil)).invalid?
  end

  test 'client_id and client_secret should not be blank when auth_method is oauth2' do
    ss = SystemSetting.new(valid_params_oauth2)
    assert ss.oauth2?
    assert ss.client_id.present?
    assert ss.client_secret.present?
    assert ss.valid?

    assert SystemSetting.new(valid_params_oauth2.merge(client_id: nil)).invalid?
    assert SystemSetting.new(valid_params_oauth2.merge(client_secret: nil)).invalid?
  end

  test 'oauth2_configured?' do
    ss = SystemSetting.new(valid_params_oauth2)
    assert_not_nil ss.credential
    assert ss.oauth2_configured?

    ss.client_id = 'no_credential'
    assert_nil ss.credential
    assert_not ss.oauth2_configured?
  end

  def valid_params
    {
      auth_method: :api_key,
      api_key: 'test_api_key'
    }
  end

  def valid_params_oauth2
    {
      auth_method: :oauth2,
      client_id: 'test_client_id',
      client_secret: 'test_client_secret'
    }
  end
end
