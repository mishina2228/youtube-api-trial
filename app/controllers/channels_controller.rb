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
    JobUtils.enqueue(Channel::BuildStatisticsJob, 'channel_id' => @channel.id)
    redirect_to @channel, notice: t('text.channel.build_statistics.start')
  end

  def build_all_statistics
    JobUtils.enqueue(Channel::BuildAllStatisticsJob)
    redirect_to channels_url, notice: t('text.channel.update_all_snippets.message')
  end

  def update_snippet
    JobUtils.enqueue(Channel::UpdateSnippetJob, 'channel_id' => @channel.id)
    redirect_to @channel, notice: t('text.channel.update_snippet.start')
  end

  def update_all_snippets
    JobUtils.enqueue(Channel::UpdateAllSnippetsJob)
    redirect_to channels_url, notice: t('text.channel.update_all_snippets.message')
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:channel_id)
  end
end
