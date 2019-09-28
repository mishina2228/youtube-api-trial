require 'test_helper'

class SystemSettingTest < ActiveSupport::TestCase
  def test_validation
    ss = SystemSetting.new(valid_params)
    assert ss.valid?

    ss = SystemSetting.new(valid_params.merge(auth_method: nil))
    assert ss.invalid?
  end

  def valid_params
    {auth_method: :api_key}
  end
end
