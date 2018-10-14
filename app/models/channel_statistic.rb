class ChannelStatistic < ApplicationRecord
  belongs_to :channel, inverse_of: :channel_statistics

  validates :view_count, numericality: {only_integer: true}, presence: true
  validates :subscriber_count, numericality: {only_integer: true}, presence: true
  validates :video_count, numericality: {only_integer: true}, presence: true
end
