class ChannelLists::SearchController < ApplicationController
  def index
    return unless params[:query]

    response = ChannelLists::Search.search(params[:query], token: params[:token])
    @search_results = ChannelLists::Search.new(response, params[:query])
  end
end
