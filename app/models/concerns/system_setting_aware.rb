# frozen_string_literal: true

module SystemSettingAware
  extend ActiveSupport::Concern

  def system_setting
    SystemSetting.first
  end
end
