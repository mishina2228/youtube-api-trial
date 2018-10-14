class Channel < ApplicationRecord
  has_many :channel_statistics, -> {order(:created_at)},
           dependent: :destroy, inverse_of: :channel

  validates :channel_id, presence: true, uniqueness: true
  validates :thumbnail_url, format: URI.regexp(%w(http https)), allow_blank: true

  def url
    "https://www.youtube.com/channel/#{channel_id}"
  end

  def build_statistics
    res = youtube_service.statistics(channel_id)
    return false if error_message(res, :channel_statistics)

    statistics = res.response
    channel_statistics.build(channel_statistics_params(statistics)).save
  end

  def update_snippet
    res = youtube_service.snippet(channel_id)
    return false if error_message(res, :snippet)

    snippet = res.response
    update(snippet_params(snippet))
  end

  def youtube_service
    return @youtube_service if @youtube_service

    ss = SystemSetting.first
    raise 'missing' unless ss

    @youtube_service = Youtube::Service.new(ss.api_key)
  end

  def channel_id=(val)
    uri = URI.parse(val).path.split('/').last if val.present?
    super(uri)
  rescue URI::InvalidURIError
    super(nil)
  end

  def error_message(res, key)
    return false if res.status_ok?

    if res.status_blank?
      errors.add(key, 'IDがあってないんじゃね')
    elsif res.status_error?
      errors.add(key, res.error.message)
    end
    true
  end

  def latest_view_count
    channel_statistics.first.try(:view_count)
  end

  def latest_subscriber_count
    channel_statistics.first.try(:subscriber_count)
  end

  def latest_video_count
    channel_statistics.first.try(:video_count)
  end

  private

  def snippet_params(snippet)
    {
      title: snippet.title,
      description: snippet.description,
      thumbnail_url: snippet.thumbnails.default.url,
      published_at: snippet.published_at
    }
  end

  def channel_statistics_params(statistics)
    {
      view_count: statistics.view_count,
      subscriber_count: statistics.subscriber_count,
      video_count: statistics.video_count
    }
  end
end
