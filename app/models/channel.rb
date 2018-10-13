class Channel < ApplicationRecord
  has_many :channel_statistics, dependent: :destroy

  validates :channel_id, presence: true
  validates :thumbnail_url, format: URI.regexp(%w(http https)), allow_blank: true

  def build_statistics
    res = youtube_service.statistics(channel_id)
    return res unless res.status_ok?

    statistics = res.response
    channel_statistics.build(
      view_count: statistics.view_count,
      subscriber_count: statistics.subscriber_count,
      video_count: statistics.video_count
    ).save!
    res
  end

  def update_snippet
    res = youtube_service.snippet(channel_id)
    return res unless res.status_ok?

    snippet = res.response
    update!(
      title: snippet.title,
      description: snippet.description,
      thumbnail_url: snippet.thumbnails.default.url,
      published_at: snippet.published_at
    )
    res
  end

  def youtube_service
    return @youtube_service if @youtube_service

    ss = SystemSetting.first
    raise 'missing' unless ss

    @youtube_service = Youtube::Service.new(ss.api_key)
  end
end
