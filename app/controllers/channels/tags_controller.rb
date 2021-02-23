class Channels::TagsController < ApplicationController
  before_action :set_channel

  def edit
    respond_to do |format|
      format.html {redirect_to @channel}
      format.js
    end
  end

  def update
    @channel.attributes = update_tags_params
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
end
