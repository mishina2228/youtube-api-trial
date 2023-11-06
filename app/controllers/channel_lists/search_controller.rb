# frozen_string_literal: true

module ChannelLists
  class SearchController < ChannelListsController
    def index
      @condition = search_condition
      return if @condition.query.blank?

      response = ChannelLists::Search.search(@condition.query, token: @condition.token, max_results: @condition.per)
      @search_results = ChannelLists::Search.new(response)
    end

    private

    def search_params
      params.fetch(:search_channel_list_condition, {})
            .permit(:query, :per, :token)
    end
  end
end
