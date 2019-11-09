class AddDisabledToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :disabled, :boolean, null: false, default: false
  end
end
