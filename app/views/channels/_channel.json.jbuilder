# frozen_string_literal: true

json.extract! channel, :id, :channel_id, :title, :description, :thumbnail_url, :created_at, :updated_at
json.url channel_url(channel, format: :json)
