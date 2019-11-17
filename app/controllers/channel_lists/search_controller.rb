class ChannelLists::SearchController < ApplicationController
  def index
    @condition = search_condition
    if request.xhr?
      response = ChannelLists::Search.search(
        @condition.query, token: @condition.token, max_results: @condition.per
      )
      @search_results = ChannelLists::Search.new(response)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def search_condition
    cond = ::Search::ChannelListCondition.new(search_params)
    cond.per ||= ChannelList::DEFAULT_PER
    cond
  end

  def search_params
    params.fetch(:search_channel_list_condition, {})
          .permit(:query, :per, :token)
  end
end
