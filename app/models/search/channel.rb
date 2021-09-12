module Search
  class Channel < Search::Base
    attr_accessor :ids, :title,
                  :subscriber_count, :video_count, :view_count, :tag
    attr_writer :disabled, :from_date, :to_date

    def search
      ret = ::Channel.preload(:channel_statistics).preload(:tags)
      ret = ret.with_channel_statistics
      ret = ret.where(id: ids) if ids.present?
      ret = ret.where('title LIKE ?', "%#{title}%") if title.present?
      ret = ret.where(published_at: published_at) if published_at.present?
      ret = ret.where(disabled: disabled) unless disabled.nil?
      ret = ret.tagged_with("'#{tag}'") if tag.present?
      ret = ret.order(sort_column)
      ret = ret.reverse_order if direction == 'desc' || direction.nil?
      ret.paginate(per: per, page: page)
    end

    def disabled
      return if @disabled.nil? || @disabled == ''

      @disabled
    end

    def from_date
      Date.parse(@from_date.to_s).beginning_of_day
    rescue TypeError, Date::Error
      nil
    end

    def to_date
      Date.parse(@to_date.to_s).end_of_day
    rescue TypeError, Date::Error
      nil
    end

    def published_at
      return if from_date.nil? && to_date.nil?

      from_date..to_date
    end

    def self.disabled_options
      {
        I18n.t('activemodel.attributes.search.disabled_options.both') => nil,
        I18n.t('activemodel.attributes.search.disabled_options.enabled_only') => false,
        I18n.t('activemodel.attributes.search.disabled_options.disabled_only') => true
      }
    end

    private

    def sort_column
      case order
      when 'title', 'published_at'
        order.to_sym
      when 'view_count', 'subscriber_count', 'video_count', 'latest_acquired_at'
        "cs.#{order}"
      else
        'cs.subscriber_count'
      end
    end
  end
end
