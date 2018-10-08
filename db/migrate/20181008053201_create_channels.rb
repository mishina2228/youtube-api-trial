class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :channel_id, null: false
      t.string :title
      t.string :description
      t.string :thumbnail_url
      t.datetime :published_at

      t.timestamps
    end
    add_index :channels, :channel_id, unique: true
  end
end
