class ChannelLists::SubscriptionsController < ApplicationController
  def index
    response = ChannelLists::Subscription.subscriptions(token: params[:token])
    @subscription = ChannelLists::Subscription.new(response)
  end
end
