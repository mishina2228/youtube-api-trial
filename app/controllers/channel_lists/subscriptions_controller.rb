# frozen_string_literal: true

module ChannelLists
  class SubscriptionsController < ChannelListsController
    def index
      @condition = search_condition
      response = ChannelLists::Subscription.subscriptions(token: @condition.token, max_results: @condition.per)
      @subscription = ChannelLists::Subscription.new(response)
    end

    private

    def search_params
      params.fetch(:search_channel_list_condition, {})
            .permit(:per, :token)
    end
  end
end
