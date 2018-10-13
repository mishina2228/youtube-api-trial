class Channel < ApplicationRecord
  has_many :channel_statistics, dependent: :destroy

  validates :channel_id, presence: true
  validates :thumbnail_url, format: URI.regexp(%w(http https))
end
