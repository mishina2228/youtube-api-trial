class Search::Channel < Search::Base
  attr_accessor :ids, :title, :from_date, :to_date,
                :subscriber_count, :video_count, :view_count

  def search
    ret = ::Channel.includes(:channel_statistics)
    ret = ret.with_channel_statistics
    ret = ret.where(id: ids) if ids.present?
    ret = ret.where('title LIKE ?', "%#{title}%") if title.present?
    ret = ret.where('published_at >= ?', from_date) if from_date.present?
    ret = ret.where('published_at <= ?', to_date) if to_date.present?
    ret = ret.order(sort_column)
    ret = ret.reverse_order if direction == 'desc' || direction.nil?
    ret.paginate(per: per, page: page)
  end

  private

  def sort_column
    case order
    when 'title', 'published_at'
      order
    when 'view_count', 'subscriber_count', 'video_count', 'latest_acquired_at'
      "cs.#{order}"
    else
      'cs.subscriber_count'
    end
  end
end
