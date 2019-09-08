class Youtube::ServiceFactory
  def self.create_service(api_key)
    if Rails.env.test?
      ::Mock::Service.new(api_key)
    else
      ::Youtube::Service.new(api_key)
    end
  end
end
