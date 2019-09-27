class AddEncryptedClientSecretToSystemSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :system_settings, :encrypted_client_secret, :string
  end
end
