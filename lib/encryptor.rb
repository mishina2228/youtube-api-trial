module Encryptor
  CIPHER = 'aes-256-cbc'.freeze

  private

  def encrypt(password)
    encryptor.encrypt_and_sign(password)
  end

  def decrypt(password)
    encryptor.decrypt_and_verify(password)
  end

  def encryptor
    secure = Rails.application.credentials.config[:secret_key_base][0..31]
    ActiveSupport::MessageEncryptor.new(secure, CIPHER)
  end
end
