# frozen_string_literal: true

module Channels
  class SnippetsController < ApplicationController
    before_action :set_channel

    def index
      channel_snippets = @channel.channel_snippets.paginate(page: params[:page], per: 5).padding(1)
      render partial: 'channels/snippets_frame', locals: {channel_snippets: channel_snippets}
    end

    private

    def set_channel
      @channel = Channel.find(params[:channel_id])
    end
  end
end
