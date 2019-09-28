class ChangeApiKeyOnSystemSettings < ActiveRecord::Migration[5.2]
  def up
    change_column_null :system_settings, :api_key, true
  end

  def down
    change_column_null :system_settings, :api_key, false
  end
end
