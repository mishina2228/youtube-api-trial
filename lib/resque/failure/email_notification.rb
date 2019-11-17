module Resque
  module Failure
    class EmailNotification < Base
      def save
        recipients = User.should_notify.pluck(:email)
        return if recipients.blank?

        mail = JobFailureNoticeMailer.with(to: recipients, exception: exception).alert
        mail.deliver_now
      rescue => e
        puts "#{e.class} #{e.message}"
        puts e.backtrace.join("\n")
      end
    end
  end
end
