require 'test_helper'

class SystemSettingTest < ActiveSupport::TestCase
  def test_validation
    ss = SystemSetting.new(valid_params)
    assert ss.valid?

    ss = SystemSetting.new(valid_params.merge(auth_method: nil))
    assert ss.invalid?
  end

  def test_validation_api_key
    ss = SystemSetting.new(valid_params)
    assert ss.api_key?
    assert ss.api_key.present?
    assert ss.valid?

    assert SystemSetting.new(valid_params.merge(api_key: nil)).invalid?
  end

  def test_validation_oauth2
    ss = SystemSetting.new(valid_params_oauth2)
    assert ss.oauth2?
    assert ss.client_id.present?
    assert ss.client_secret.present?
    assert ss.valid?

    assert SystemSetting.new(valid_params_oauth2.merge(client_id: nil)).invalid?
    assert SystemSetting.new(valid_params_oauth2.merge(client_secret: nil)).invalid?
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
