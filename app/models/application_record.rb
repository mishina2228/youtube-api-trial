class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  DEFAULT_PER = 10
  MAX_PER = 50

  def self.paginate(page:, per:)
    per = (per || DEFAULT_PER).to_i
    per = MAX_PER if per > MAX_PER
    page(page.to_i).per(per)
  end
end
