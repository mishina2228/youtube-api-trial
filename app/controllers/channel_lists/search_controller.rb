class ChannelLists::SearchController < ApplicationController
  def index
    if params[:query].present?
      response = ChannelLists::Search.search(params[:query], token: params[:token], max_results: 5)
      @search_results = ChannelLists::Search.new(response, params[:query])
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end
