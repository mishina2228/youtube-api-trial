require 'test_helper'

module Resque
  module Failure
    class EmailNotificationTest < ActiveSupport::TestCase
      def test_save
        notification = Resque::Failure::EmailNotification.new(
          sample_exception, 'worker', 'queue', 'payload'
        )

        assert notification.recipients.empty?, '通知対象ユーザーがいないことを確認'
        assert_nil notification.save

        u = users(:admin)
        assert u.update(email: 'admin@real_domain.com')
        assert notification.recipients.present?, '通知対象ユーザーがいることを確認'
        mail = notification.save
        assert mail.present?, 'メールが送信されること'
      end
    end
  end
end
