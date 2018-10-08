class SystemSetting < ApplicationRecord
  validates :api_key, presence: true
end
