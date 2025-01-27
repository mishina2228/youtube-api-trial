# frozen_string_literal: true

module Channels
  class TagsController < ApplicationController
    before_action :set_channel

    def edit
      render partial: 'form_tag_list', locals: {channel: @channel}
    end

    def update
      if set_tag_list(@channel) && @channel.save
        redirect_to @channel, notice: t('text.channel.update_tags.success')
      else
        redirect_to @channel, alert: t('text.channel.update_tags.error')
      end
    end

    private

    def set_channel
      @channel = Channel.find(params[:channel_id])
    end

    def set_tag_list(channel) # rubocop:disable Naming/AccessorMethodName
      tag_list_was = channel.tag_list
      channel.tag_list = [] # clear existing tags
      begin
        channel.tag_list.add(params.dig(:channel, :tag_list), parser: ChannelTag::Parser)
        true
      rescue ChannelTag::ParseError
        channel.tag_list = tag_list_was # reset to original value
        false
      end
    end
  end
end
