class CreateChannelStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_statuses do |t|
      t.belongs_to :channel, index: true, null: false
      t.integer :view_count, null: false, default: 0
      t.integer :subscriber_count, null: false, default: 0
      t.integer :video_count, null: false, default: 0

      t.timestamps
    end
  end
end
