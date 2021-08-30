require 'test_helper'

module Resque
  module Failure
    class EmailNotificationTest < ActiveSupport::TestCase
      test 'save' do
        notification = Resque::Failure::EmailNotification.new(
          sample_exception, 'worker', 'queue', 'payload'
        )

        assert_empty notification.recipients, 'confirm that there are no users to be notified'
        assert_nil notification.save

        u = users(:admin)
        assert u.update(email: 'admin@real_domain.com')
        assert notification.recipients.present?, 'confirm that there are users to be notified'
        mail = notification.save
        assert mail.present?, 'email should be sent'
      end

      test 'output_error_details' do
        notification = Resque::Failure::EmailNotification.new(
          sample_exception, 'worker', 'queue', 'payload'
        )
        u = users(:admin)
        assert u.update(email: 'admin@real_domain.com')
        assert notification.recipients.present?

        JobFailureNoticeMailer.stub(:with, ->(_options) {raise 'mock error'}) do
          assert_output(/RuntimeError mock error/) {notification.save}
        end
      end
    end
  end
end
