# frozen_string_literal: true

module Channels
  class StatisticsController < ApplicationController
    before_action :set_channel

    def index
      return redirect_to channel_path(@channel) unless turbo_frame_request?

      channel_statistics = @channel.channel_statistics.paginate(page: params[:page], per: params[:per])
      render partial: 'channels/statistics_frame', locals: {channel_statistics: channel_statistics}
    end

    private

    def set_channel
      @channel = Channel.find(params[:channel_id])
    end
  end
end
