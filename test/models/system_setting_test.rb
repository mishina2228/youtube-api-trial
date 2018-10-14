require 'test_helper'

class SystemSettingTest < ActiveSupport::TestCase
  def test_validation
    ss = SystemSetting.new(valid_params)
    assert ss.valid?

    ss = SystemSetting.new(valid_params.merge(api_key: nil))
    assert ss.invalid?
  end

  def valid_params
    {api_key: 'test_api_key'}
  end
end
