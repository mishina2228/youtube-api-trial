# frozen_string_literal: true

class Channel < ApplicationRecord
  include SystemSettingAware

  has_many :channel_statistics, -> {order(created_at: :desc)},
           dependent: :destroy, inverse_of: :channel
  has_many :channel_snippets, -> {order(created_at: :desc)},
           dependent: :destroy, inverse_of: :channel

  validates :channel_id, presence: {message: proc {I18n.t('text.channel.channel_id.invalid')}}
  validates :channel_id, uniqueness: true
  validates :thumbnail_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
                            allow_blank: true

  acts_as_taggable_on :tags

  DEFAULT_PER = 50
  MAX_PER = 100
  PER_LIST = [5, 10, 20, DEFAULT_PER, 75, MAX_PER].freeze

  def self.with_channel_statistics
    with_rownum = ChannelStatistic.select(:channel_id, :view_count, :subscriber_count, :video_count, :created_at)
                                  .select('row_number() over (partition by channel_id order by created_at desc) rownum')
    statistics = ChannelStatistic.select('*')
                                 .from(with_rownum, :with_rownum)

    columns = %w[channels.id channels.title channels.thumbnail_url channels.published_at channels.disabled]
    columns += ['cs.subscriber_count', 'cs.view_count', 'cs.video_count', 'cs.created_at as latest_acquired_at']
    columns += [
      'second_cs.subscriber_count as second_latest_subscriber_count',
      'second_cs.view_count as second_latest_view_count',
      'second_cs.video_count as second_latest_video_count',
      'second_cs.created_at as second_latest_acquired_at'
    ]
    Channel.with(with_rownum: statistics)
           .joins('LEFT JOIN with_rownum as cs ON cs.rownum = 1 AND channels.id = cs.channel_id')
           .joins('LEFT JOIN with_rownum as second_cs ON second_cs.rownum = 2 AND channels.id = second_cs.channel_id')
           .select(*columns)
  end

  def save_and_set_job
    return false unless save

    JobUtils.enqueue(Channels::BuildStatisticsJob, 'channel_id' => id)
    JobUtils.enqueue(Channels::UpdateSnippetJob, 'channel_id' => id)
    true
  end

  def url
    "https://www.youtube.com/channel/#{channel_id}"
  end

  def build_statistics!
    res = youtube_service.statistics(channel_id)
    raise res.error if res.error.present?

    statistics = res.response
    channel_statistics.create!(channel_statistics_params(statistics))
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
    Time.zone.parse(self[:latest_acquired_at]) if self[:latest_acquired_at]
  end

  def second_latest_acquired_at
    Time.zone.parse(self[:second_latest_acquired_at]) if self[:second_latest_acquired_at]
  end

  def medium_thumbnail_url
    thumbnail_url&.gsub('s88-', 's240-')
  end

  def high_thumbnail_url
    thumbnail_url&.gsub('s88-', 's800-')
  end

  def enabled?
    !disabled?
  end

  def tag_list_json
    tag_list.map {|tag| {value: tag}}.to_json
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
      subscriber_count: statistics.hidden_subscriber_count ? 0 : statistics.subscriber_count,
      video_count: statistics.video_count
    }
  end
end
