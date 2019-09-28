class AddAuthMethodToSystemSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :system_settings, :auth_method, :integer, null: false, default: 0
  end
end
