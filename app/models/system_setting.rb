class SystemSetting < ApplicationRecord
  include Encryptor

  attr_accessor :client_secret

  before_save :encrypt_client_secret
  after_initialize :decrypt_client_secret

  validates :api_key, presence: true

  private

  def encrypt_client_secret
    self.encrypted_client_secret = encrypt(client_secret) if client_secret
  end

  def decrypt_client_secret
    self.client_secret = decrypt(encrypted_client_secret) if encrypted_client_secret
  end
end
