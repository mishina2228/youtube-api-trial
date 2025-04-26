# frozen_string_literal: true

class ChangeViewCountOnChannelStatistics < ActiveRecord::Migration[8.0]
  def up
    change_column_null :channel_statistics, :view_count, true
    change_column_default :channel_statistics, :view_count, from: 0, to: nil
  end

  def down
    change_column_null :channel_statistics, :view_count, false, 0
    change_column_default :channel_statistics, :view_count, from: nil, to: 0
  end
end
