class Channel < ApplicationRecord
  include SystemSettingAware
  extend SystemSettingAware

  has_many :channel_statistics, -> {order('created_at DESC')},
           dependent: :destroy, inverse_of: :channel
  has_many :channel_snippets, -> {order('created_at DESC')},
           dependent: :destroy, inverse_of: :channel

  validates :channel_id, presence: {message: proc {I18n.t('text.channel.channel_id.invalid')}}
  validates :channel_id, uniqueness: true
  validates :thumbnail_url, format: URI::DEFAULT_PARSER.make_regexp(%w(http https)),
                            allow_blank: true

  acts_as_taggable_on :tags

  def self.with_channel_statistics
    cs = ChannelStatistic.select(:channel_id, :view_count, :subscriber_count, :video_count)
                         .select('max(channel_statistics.created_at) as latest_acquired_at')
                         .group(:channel_id)
    Channel.joins("INNER JOIN (#{cs.to_sql}) as cs ON channels.id = cs.channel_id")
           .select('"channels".*, cs.subscriber_count, cs.view_count, cs.video_count, cs.latest_acquired_at')
  end

  def self.use_oauth2?
    return false unless system_setting

    system_setting.oauth2? && system_setting.oauth2_configured?
  end

  def save_and_set_job
    return false unless save

    JobUtils.enqueue(Channel::BuildStatisticsJob, 'channel_id' => id)
    JobUtils.enqueue(Channel::UpdateSnippetJob, 'channel_id' => id)
    true
  end

  def url
    "https://www.youtube.com/channel/#{channel_id}"
  end

  def build_statistics!
    res = youtube_service.statistics(channel_id)
    raise res.error if res.error.present?

    statistics = res.response
    channel_statistics.build(channel_statistics_params(statistics)).save!
  end

  def update_snippet!
    res = youtube_service.snippet(channel_id)
    raise res.error if res.error.present?

    snippet = res.response
    self.attributes = snippet_params(snippet)
    return unless has_changes_to_save?

    channel_snippets.create!(channel_snippet_params(snippet))
    save!
  end

  def youtube_service
    return @youtube_service if @youtube_service
    raise t('text.system_setting.missing') unless system_setting

    @youtube_service = system_setting.youtube_service
  end

  def channel_id=(val)
    super(parse_channel_id(val))
  end

  def latest_acquired_at
    Time.zone.parse self[:latest_acquired_at]
  end

  def second_latest_statistics
    channel_statistics.second
  end

  def second_latest_view_count
    second_latest_statistics&.view_count
  end

  def second_latest_subscriber_count
    second_latest_statistics&.subscriber_count
  end

  def second_latest_video_count
    second_latest_statistics&.video_count
  end

  def second_latest_acquired_at
    second_latest_statistics&.created_at
  end

  def medium_thumbnail_url
    thumbnail_url&.gsub(/s88-/, 's240-')
  end

  def high_thumbnail_url
    thumbnail_url&.gsub(/s88-/, 's800-')
  end

  def enabled?
    !disabled?
  end

  private

  def parse_channel_id(val)
    uri = URI.parse(val)
    if (m = uri.path.match(Consts::Youtube::REGEXP_URL))
      m[:channel_id]
    end
  rescue URI::InvalidURIError
    nil
  end

  def snippet_params(snippet)
    {
      title: snippet.title,
      description: snippet.description,
      thumbnail_url: snippet.thumbnails.default.url,
      published_at: snippet.published_at
    }
  end

  def channel_snippet_params(snippet)
    {
      title: snippet.title,
      description: snippet.description,
      thumbnail_url: snippet.thumbnails.default.url
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
