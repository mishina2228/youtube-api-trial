module SystemSettingSupport
  def system_setting
    return @system_setting if @system_setting

    @system_setting = system_settings(:system_setting)
    @system_setting.client_secret = 'test_client_secret'
    assert @system_setting.save
    @system_setting
  end
end
