# frozen_string_literal: true

class ChannelListsController < ApplicationController
  def create
    return redirect_to action: :index unless turbo_frame_request?

    @channel = Channel.new(channel_params)
    if @channel.save_and_set_job
      render partial: 'channel_lists/partials/channel_row', locals: {channel: @channel}
    else
      @channel.errors.add(:base, I18n.t('helpers.link.channel_create_failed'))
      render partial: 'channel_lists/partials/channel_row', locals: {channel: @channel}, status: :unprocessable_entity
    end
  end

  private

  def search_condition
    cond = ::Search::ChannelListCondition.new(search_params)
    cond.per ||= ChannelList::DEFAULT_PER
    cond
  end

  def search_params
    raise 'Must be implemented in an inherited class.'
  end

  def channel_params
    params.require(:channel).permit(:channel_id, :thumbnail_url, :title, :description)
  end
end
