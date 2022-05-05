# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, I18n.t('errors.messages.url_invalid')) unless valid_url?(value)
  end

  def valid_url?(url)
    url = begin
            URI.parse(url)
          rescue
            false
          end
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end
