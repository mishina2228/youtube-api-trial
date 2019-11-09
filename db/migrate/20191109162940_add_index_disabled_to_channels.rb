class AddIndexDisabledToChannels < ActiveRecord::Migration[5.2]
  def change
    add_index :channels, :disabled
  end
end
