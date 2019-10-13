class SubscriptionsController < ApplicationController
  before_action :set_system_setting

  def index
    return redirect_to channels_path unless @system_setting&.oauth2?

    response = @system_setting.subscriptions(token: params[:token])
    @subscription = Subscription.new(response)
  end

  private

  def set_system_setting
    @system_setting = SystemSetting.first
  end
end
