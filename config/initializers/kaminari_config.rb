# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 15
  # config.max_per_page = nil
  config.window = 5
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end
