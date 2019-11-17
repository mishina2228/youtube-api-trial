class JobFailureNoticeMailer < ApplicationMailer
  def alert
    to = params.fetch(:to)
    @exception = params.fetch(:exception)
    mail(to: to)
  end
end
