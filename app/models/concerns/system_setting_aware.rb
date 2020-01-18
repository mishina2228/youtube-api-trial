module SystemSettingAware
  extend ActiveSupport::Concern

  def system_setting
    SystemSetting.first
  end
end
