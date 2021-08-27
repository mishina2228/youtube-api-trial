module Encryptor
  CIPHER = 'aes-256-cbc'.freeze
  TEST_SECRET = 'c0b469b8a1c0baf224c837bec3acafe6'.freeze

  private

  def encrypt(password)
    encryptor.encrypt_and_sign(password)
  end

  def decrypt(password)
    encryptor.decrypt_and_verify(password)
  end

  def encryptor
    ActiveSupport::MessageEncryptor.new(secret, CIPHER)
  end

  def secret
    if Rails.env.test?
      TEST_SECRET
    else
      Rails.application.credentials.config[:secret_key_base][0..31]
    end
  end
end
