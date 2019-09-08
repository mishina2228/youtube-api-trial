class ChannelsController < ApplicationController
  VALID_SORT_COLUMNS = %w(title published_at).freeze
  before_action :set_channel, only: [
    :show, :edit, :update, :destroy, :build_statistics, :update_snippet
  ]
  before_action -> {require_data(channels_url, Channel)},
                only: [:build_all_statistics, :update_all_snippets]
  authorize_resource

  def index
    order = params[:order] if VALID_SORT_COLUMNS.include?(params[:order])
    @channels = Channel.includes(:channel_statistics)
                       .order(order)
    @channels = @channels.reverse_order if params[:desc].present?
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
      message << @channel.errors.full_messages
      redirect_to channels_url, alert: message.flatten
    end
  end

  def build_all_statistics
    success = []
    failure = []
    Channel.find_each do |channel|
      channel.build_statistics ? success << channel : failure << channel
    end
    message = []
    message << t('text.channel.build_all_statistics.message')
    message << t('text.common.success_count', count: success.count)
    message << t('text.common.failure_count', count: failure.count)
    redirect_to channels_url, notice: message
  end

  def update_snippet
    if @channel.update_snippet
      redirect_to @channel, notice: t('text.channel.update_snippet.success')
    else
      message = []
      message << t('text.channel.update_snippet.error')
      message << @channel.errors.full_messages
      redirect_to channels_url, alert: message.flatten
    end
  end

  def update_all_snippets
    success = []
    failure = []
    Channel.find_each do |channel|
      channel.update_snippet ? success << channel : failure << channel
    end
    message = []
    message << t('text.channel.update_all_snippets.message')
    message << t('text.common.success_count', count: success.count)
    message << t('text.common.failure_count', count: failure.count)
    redirect_to channels_url, notice: message
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:channel_id)
  end
end
