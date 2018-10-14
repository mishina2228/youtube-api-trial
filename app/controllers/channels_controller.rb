class ChannelsController < ApplicationController
  before_action :set_channel,
                only: [:show, :edit, :update, :destroy, :build_statistics, :update_snippet]

  def index
    @channels = Channel.all
  end

  def show
  end

  def new
    @channel = Channel.new
  end

  def edit
  end

  def create
    @channel = Channel.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html {redirect_to @channel, notice: t('helpers.notice.create')}
        format.json {render :show, status: :created, location: @channel}
      else
        format.html {render :new}
        format.json {render json: @channel.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html {redirect_to @channel, notice: t('helpers.notice.update')}
        format.json {render :show, status: :ok, location: @channel}
      else
        format.html {render :edit}
        format.json {render json: @channel.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @channel.destroy
    respond_to do |format|
      format.html {redirect_to channels_url, notice: t('helpers.notice.delete')}
      format.json {head :no_content}
    end
  end

  def build_statistics
    if @channel.build_statistics
      redirect_to @channel, notice: t('text.channel.build_statistics.success')
    else
      message = []
      message << t('text.channel.build_statistics.error')
      message << @channel.errors
      redirect_to channels_url, alert: message
    end
  end

  def update_snippet
    if @channel.update_snippet
      redirect_to @channel, notice: t('text.channel.update_snippet.success')
    else
      message = []
      message << t('text.channel.update_snippet.error')
      message << @channel.errors
      redirect_to channels_url, alert: message
    end
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:channel_id)
  end
end
