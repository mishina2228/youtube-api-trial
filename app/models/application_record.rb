class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  DEFAULT_PER = 10
  MAX_PER = 50

  def self.paginate(page:, per:)
    page(page.to_i).per(proper_per(per))
  end

  def self.proper_per(per)
    per = per.to_i
    if per <= 0
      const_get(:DEFAULT_PER)
    elsif per > const_get(:MAX_PER)
      const_get(:MAX_PER)
    else
      per
    end
  end
end
