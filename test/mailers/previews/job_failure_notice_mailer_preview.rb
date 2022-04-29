# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/job_failure_notice_mailer
class JobFailureNoticeMailerPreview < ActionMailer::Preview
  def alert
    exception = Mishina::Youtube::NoChannelError.new('test_channel_id')
    backtrace = [
      '..app/jobs/channel/build_statistics_job.rb:22:in `perform`',
      '..app/models/channel.rb:38:in `build_statistics!`'
    ]
    exception.set_backtrace(backtrace)
    JobFailureNoticeMailer.with(to: 'test_to@example.com', exception: exception).alert
  end
end
