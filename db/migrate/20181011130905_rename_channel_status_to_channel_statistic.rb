class RenameChannelStatusToChannelStatistic < ActiveRecord::Migration[5.2]
  def change
    rename_table :channel_statuses, :channel_statistics
  end
end
