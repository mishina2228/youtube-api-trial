class AddClientIdToSystemSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :system_settings, :client_id, :string
  end
end
