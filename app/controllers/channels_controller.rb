class ChannelsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :set_channel, only: [
    :show, :destroy, :build_statistics, :update_snippet, :enable
  ]
  before_action -> {require_data(channels_url, Channel)}, only: [:build_all_statistics, :update_all_snippets]
  authorize_resource

  def index
    @search_channel = search_condition
    @channels = @search_channel.search

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @channel_statistics = @channel.channel_statistics.paginate(per: params[:statics_per], page: params[:statics_page])
    @channel_snippets = @channel.channel_snippets.limit(5).offset(1)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)

    respond_to do |format|
      if @channel.save_and_set_job
        format.html {redirect_to @channel, notice: t('helpers.notice.create')}
        format.json {render :show, status: :created, location: @channel}
      else
        format.html {render :new}
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
    JobUtils.enqueue(Channels::BuildStatisticsJob, 'channel_id' => @channel.id)
    respond_to do |format|
      format.html {redirect_to @channel, notice: t('text.channel.build_statistics.start')}
      format.json {render json: {message: t('text.channel.build_statistics.start')}.to_json}
    end
  end

  def build_all_statistics
    JobUtils.enqueue(Channels::BuildAllStatisticsJob)
    respond_to do |format|
      format.html {redirect_to channels_url, notice: t('text.channel.build_all_statistics.start')}
      format.json {render json: {message: t('text.channel.build_all_statistics.start')}.to_json}
    end
  end

  def update_snippet
    JobUtils.enqueue(Channels::UpdateSnippetJob, 'channel_id' => @channel.id)
    respond_to do |format|
      format.html {redirect_to @channel, notice: t('text.channel.update_snippet.start')}
      format.json {render json: {message: t('text.channel.update_snippet.start')}.to_json}
    end
  end

  def update_all_snippets
    JobUtils.enqueue(Channels::UpdateAllSnippetsJob)
    respond_to do |format|
      format.html {redirect_to channels_url, notice: t('text.channel.update_all_snippets.start')}
      format.json {render json: {message: t('text.channel.update_all_snippets.start')}.to_json}
    end
  end

  def enable
    respond_to do |format|
      if @channel.update(disabled: false)
        format.html {redirect_to @channel, notice: t('text.channel.enable.succeeded')}
        format.json {render json: {message: t('text.channel.enable.succeeded')}.to_json}
      else
        format.html {redirect_to @channel, notice: t('text.channel.enable.failed')}
        format.json {render json: {message: t('text.channel.enable.failed')}.to_json}
      end
    end
  end

  protected

  def take_params
    super.merge(search_channel: search_params)
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:channel_id)
  end

  def search_params
    search_channel = params.fetch(:search_channel, {})
    hash = {order: params[:order], direction: params[:direction]}
    attributes = [
      :title, :subscriber_count_from, :subscriber_count_to, :from_date, :to_date,
      :view_count_from, :view_count_to, :video_count_from, :video_count_to,
      :per, :disabled, :tag
    ]
    attributes.each_with_object(hash) {|attr, h| h[attr] = search_channel[attr]}.compact_blank
  end

  def search_condition
    cond = Search::Channel.new(search_params)
    cond.per ||= params[:per] || Channel::DEFAULT_PER
    cond.page = params[:page]
    cond
  end

  def sort_column
    params[:order] || 'subscriber_count'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
