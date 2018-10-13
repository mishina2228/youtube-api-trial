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
        format.html {redirect_to @channel, notice: 'Channel was successfully created.'}
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
        format.html {redirect_to @channel, notice: 'Channel was successfully updated.'}
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
      format.html {redirect_to channels_url, notice: 'Channel was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def build_statistics
    res = @channel.build_statistics
    if res.status_ok?
      redirect_to @channel, notice: 'うまくいった'
    else
      message = []
      message << 'しっぱいです'
      message << res.error_message
      redirect_to channels_url, alert: message
    end
  end

  def update_snippet
    res = @channel.update_snippet
    if res.status_ok?
      redirect_to @channel, notice: 'うまくいった'
    else
      message = []
      message << 'しっぱいです'
      message << res.error_message
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
