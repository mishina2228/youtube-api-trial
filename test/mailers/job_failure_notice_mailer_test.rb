require 'test_helper'

class JobFailureNoticeMailerTest < ActionMailer::TestCase
  def test_alert
    exception = Mishina::Youtube::NoChannelError.new('test_channel_id')
    backtrace = [
      '..app/jobs/channel/build_statistics_job.rb:22:in `perform`',
      '..app/models/channel.rb:38:in `build_statistics!`'
    ]
    exception.set_backtrace(backtrace)
    mail = JobFailureNoticeMailer.with(to: 'test_to@example.com', exception: exception).alert
    assert_equal I18n.t('job_failure_notice_mailer.alert.subject'), mail.subject
    assert mail.body.to_s.scan(/\R/).all? {|c| c == "\r\n"}, '改行コードがCRLFであること'
    assert_includes mail.body.to_s, I18n.t('job_failure_notice_mailer.alert.error_summary')
    assert_includes mail.body.to_s, I18n.t('job_failure_notice_mailer.alert.error_backtrace')
  end
end
