# frozen_string_literal: true

yml_path = Rails.root.join('config/mail.yml')
if File.exist?(yml_path)
  options = YAML.safe_load_file(yml_path, aliases: true)[Rails.env]
  if options
    Rails.application.config.action_mailer.merge!(
      options.deep_symbolize_keys.slice(:delivery_method, :smtp_settings)
    )
  end
end
