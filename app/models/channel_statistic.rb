class ChannelStatistic < ApplicationRecord
  belongs_to :channel

  validates :view_count, numericality: {only_integer: true}
  validates :subscriber_count, numericality: {only_integer: true}
  validates :video_count, numericality: {only_integer: true}
end
