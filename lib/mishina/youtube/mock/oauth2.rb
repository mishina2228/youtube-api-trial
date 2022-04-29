# frozen_string_literal: true

require 'googleauth/user_refresh'

module Mishina
  module Youtube
    module Mock
      module Oauth2
        def credential
          if client_id == 'no_credential'
            nil
          else
            Google::Auth::UserRefreshCredentials.new
          end
        end

        def authorization_url
          'dummy_authorization_url'
        end

        def store_credential(_code)
          'dummy_store_credential'
        end
      end
    end
  end
end
