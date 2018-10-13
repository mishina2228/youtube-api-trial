class Youtube::ServiceResponse
  attr_accessor :status, :response, :error_message

  def initialize(status, response, error_message)
    self.status = status
    self.response = response
    self.error_message = error_message
  end

  def status_name
    Statuses::STATUS[status]
  end

  def status_ok?
    status == Statuses::OK
  end
end
