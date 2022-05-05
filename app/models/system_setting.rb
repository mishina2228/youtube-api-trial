# frozen_string_literal: true

class SystemSetting < ApplicationRecord
  include Encryptor
  include Mishina::Youtube::Oauth2Factory
  extend SystemSettingAware

  attr_accessor :client_secret

  enum auth_method: {nothing: 0, api_key: 1, oauth2: 2}

  after_initialize :decrypt_client_secret
  before_save :encrypt_client_secret

  validates :auth_method, presence: true
  validates :api_key, presence: true, if: :api_key?
  validates :client_id, presence: true, if: :oauth2?
  validates :client_secret, presence: true, if: :oauth2?

  def self.auth_methods_i18n_without_nothing
    auth_methods_i18n.reject {|k, _v| k.to_sym == :nothing}
  end

  def self.use_oauth2?
    return false unless system_setting

    system_setting.use_oauth2?
  end

  def self.auth_configured?
    return false unless system_setting

    system_setting.api_key? || system_setting.use_oauth2?
  end

  def use_oauth2?
    oauth2? && oauth2_configured?
  end

  def oauth2_configured?
    credential.present?
  end

  def youtube_service
    return @youtube_service if @youtube_service

    @youtube_service = Mishina::Youtube::ServiceFactory.create_service(service_params)
  end

  private

  def service_params
    case auth_method.to_sym
    when :api_key
      {api_key: api_key}
    when :oauth2
      {credentials: credential}
    end
  end

  def encrypt_client_secret
    self.encrypted_client_secret = encrypt(client_secret) if client_secret
  end

  def decrypt_client_secret
    self.client_secret = decrypt(encrypted_client_secret) if encrypted_client_secret
  end
end
