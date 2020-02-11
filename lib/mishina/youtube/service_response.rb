class Mishina::Youtube::ServiceResponse
  attr_accessor :status, :response, :error

  def initialize(status, response, error)
    self.status = status
    self.response = response
    self.error = error
  end
end
