class Mishina::Youtube::ServiceResponse
  attr_accessor :status, :response, :error

  def initialize(status, response, error)
    self.status = status
    self.response = response
    self.error = error
  end

  def status_name
    Consts::Statuses::STATUS[status]
  end

  def status_ok?
    status == Consts::Statuses::OK
  end

  def status_blank?
    status == Consts::Statuses::BLANK
  end

  def status_error?
    status == Consts::Statuses::ERROR
  end
end
