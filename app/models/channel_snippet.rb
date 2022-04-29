# frozen_string_literal: true

class ChannelSnippet < ApplicationRecord
  belongs_to :channel, inverse_of: :channel_snippets
end
