class ChannelLists::SubscriptionsController < ApplicationController
  def index
    response = ChannelLists::Subscription.subscriptions(token: params[:token], max_results: 3)
    @subscription = ChannelLists::Subscription.new(response)
  end
end
