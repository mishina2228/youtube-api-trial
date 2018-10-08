class CreateSystemSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :system_settings do |t|
      t.string :api_key, null: false

      t.timestamps
    end
  end
end
