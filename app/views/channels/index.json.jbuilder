# frozen_string_literal: true

json.array! @channels, partial: 'channels/channel', as: :channel
