class AddColumnRedirectUriToSystemSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :system_settings, :redirect_uri, :string
  end
end
