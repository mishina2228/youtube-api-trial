# frozen_string_literal: true

module ChannelLists
  class SubscriptionsController < ChannelListsController
    include SystemSettingAware

    def index
      return redirect_to root_url, notice: t('helpers.notice.oauth2_required') unless system_setting.oauth2?

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
