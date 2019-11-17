yml_path = Rails.root.join('config', 'mail.yml')
if File.exist?(yml_path)
  options = YAML.load_file(yml_path)[Rails.env]
  Rails.application.config.action_mailer.merge!(options.deep_symbolize_keys!) if options
end
