class Channels::TagsController < ApplicationController
  before_action :set_channel

  def edit
    respond_to do |format|
      format.html {redirect_to @channel}
      format.js
    end
  end

  def update
    set_tag_list(@channel)
    respond_to do |format|
      if @channel.save
        format.html {redirect_to @channel, notice: t('text.channel.update_tags.success')}
        format.js {render 'update'}
      else
        format.html {redirect_to @channel, notice: t('text.channel.update_tags.error')}
        format.js {render 'edit', locals: {error_message: t('text.channel.update_tags.error')}}
      end
    end
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def update_tags_params
    params.require(:channel).permit(:tag_list)
  end

  def set_tag_list(channel)
    tag_list_was = channel.tag_list
    channel.tag_list = [] # clear existing tags
    begin
      channel.tag_list.add(params.dig(:channel, :tag_list), parser: ChannelTag::Parser)
    rescue ChannelTag::ParseError
      channel.tag_list = tag_list_was # reset to original value
    end
  end
end
