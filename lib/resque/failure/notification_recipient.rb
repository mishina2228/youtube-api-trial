# frozen_string_literal: true

module Resque
  module Failure
    module NotificationRecipient
      def recipients
        User.should_notify.pluck(:email)
      end
    end
  end
end
