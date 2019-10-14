class SubscriptionsController < ApplicationController
  def index
    response = Subscription.subscriptions(token: params[:token])
    @subscription = Subscription.new(response)
  end
end
