module Mishina::Youtube::Mock::Oauth2
  def credential
    'dummy_credential'
  end

  def authorization_url
    'dummy_authorization_url'
  end

  def store_credential(code)
    'dummy_store_credential'
  end
end
