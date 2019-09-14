module ApplicationHelper
  def render_notices
    render partial: 'partials/notices'
  end

  def print_link(body, url, alt = 'body is missing')
    if body.present?
      link_to body, url
    else
      link_to alt, url
    end
  end

  def print_datetime(datetime, format: :long)
    l(datetime, format: format) if datetime
  end

  def print_acquired_at(datetime)
    "#{print_datetime(datetime)} (#{print_time_ago_in_words(datetime)})" if datetime
  end

  def print_comparison_period(datetime1, datetime2)
    diff = print_diff_datetimes(datetime1, datetime2)
    "#{t('text.channel.statistics.comparison')}: #{diff}" if diff
  end

  def print_number(number)
    number&.to_s(:delimited)
  end

  def print_diff_numbers(num1, num2)
    return if num1.blank? || num2.blank?

    ret = print_number(diff = num1 - num2)
    if diff.positive?
      ret = '+' + ret
    elsif diff.zero?
      ret = '±' + ret
    end
    ret
  end

  def print_diff_datetimes(datetime1, datetime2)
    return if datetime1.blank? || datetime2.blank?

    distance_of_time_in_words(datetime1, datetime2)
  end

  def print_time_ago_in_words(datetime)
    return if datetime.blank?

    I18n.t('text.channel.statistics.elapsed_time', time: time_ago_in_words(datetime))
  end

  def text_url_to_link(text)
    return if text.blank?

    URI.extract(text, %w(http https)).uniq.each do |url|
      text.gsub!(url, link_to(url, url))
    end
    text
  end
end
