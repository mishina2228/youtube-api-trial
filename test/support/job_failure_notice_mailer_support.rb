module JobFailureNoticeMailerSupport
  def sample_exception
    exception = Mishina::Youtube::NoChannelError.new('test_channel_id')
    backtrace = [
      '..app/jobs/channel/build_statistics_job.rb:22:in `perform`',
      '..app/models/channel.rb:38:in `build_statistics!`'
    ]
    exception.set_backtrace(backtrace)
    exception
  end
end
