require 'google/apis/youtube_v3'
require 'googleauth/stores/file_token_store'

module Mishina::Youtube::Oauth2
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY # View your YouTube account

  def credential
    authorizer.get_credentials('default')
  end

  def authorization_url
    authorizer.get_authorization_url(base_url: OOB_URI)
  end

  def store_credential(code)
    authorizer.get_and_store_credentials_from_code(user_id: 'default', code: code, base_url: OOB_URI)
  end

  private

  def authorizer
    auth_client = Google::Auth::ClientId.new(client_id, client_secret)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: Consts::Youtube::CREDENTIAL_YML_PATH)
    Google::Auth::UserAuthorizer.new(auth_client, SCOPE, token_store)
  end
end
