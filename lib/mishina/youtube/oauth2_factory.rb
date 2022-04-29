# frozen_string_literal: true

module Mishina
  module Youtube
    module Oauth2Factory
      if Rails.env.test?
        include Mishina::Youtube::Mock::Oauth2
      else
        include Mishina::Youtube::Oauth2
      end
    end
  end
end
