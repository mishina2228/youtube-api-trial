# frozen_string_literal: true

yml_path = Rails.root.join('config/mail.yml')
if File.exist?(yml_path)
  options = YAML.safe_load_file(
    yml_path, aliases: true, symbolize_names: true, permitted_classes: [Symbol]
  )[Rails.env.to_sym]
  if options
    Rails.application.config.action_mailer.merge!(
      options.slice(:delivery_method, :smtp_settings)
    )
  end
end
