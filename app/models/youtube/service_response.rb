class Youtube::ServiceResponse
  attr_accessor :status, :response, :error

  def initialize(status, response, error)
    self.status = status
    self.response = response
    self.error = error
  end

  def status_name
    Statuses::STATUS[status]
  end

  def status_ok?
    status == Statuses::OK
  end

  def status_blank?
    status == Statuses::BLANK
  end

  def status_error?
    status == Statuses::ERROR
  end
end
