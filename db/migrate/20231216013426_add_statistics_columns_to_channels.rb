class AddStatisticsColumnsToChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :channels, :latest_view_count, :integer
    add_column :channels, :latest_subscriber_count, :integer
    add_column :channels, :latest_video_count, :integer
    add_column :channels, :latest_acquired_at, :datetime
    add_column :channels, :second_latest_view_count, :integer
    add_column :channels, :second_latest_subscriber_count, :integer
    add_column :channels, :second_latest_video_count, :integer
    add_column :channels, :second_latest_acquired_at, :datetime
  end
end
