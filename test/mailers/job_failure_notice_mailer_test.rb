require 'test_helper'

class JobFailureNoticeMailerTest < ActionMailer::TestCase
  test 'alert' do
    mail = JobFailureNoticeMailer.with(to: 'test_to@example.com', exception: sample_exception).alert
    assert_equal I18n.t('job_failure_notice_mailer.alert.subject'), mail.subject
    assert mail.body.to_s.scan(/\R/).all? {|c| c == "\r\n"}, 'line feed code should be CRLF'
    assert_includes mail.body.to_s, I18n.t('job_failure_notice_mailer.alert.error_summary')
    assert_includes mail.body.to_s, I18n.t('job_failure_notice_mailer.alert.error_backtrace')
  end
end
