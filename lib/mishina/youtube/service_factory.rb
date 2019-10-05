class Mishina::Youtube::ServiceFactory
  def self.create_service(options = {})
    if Rails.env.test?
      Mishina::Youtube::Mock::Service.new(options)
    else
      Mishina::Youtube::Service.new(options)
    end
  end
end
