class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  DEFAULT_PER = 10
  MAX_PER = 50

  def self.paginate(params)
    per = (params[:per] || DEFAULT_PER).to_i
    per = MAX_PER if per > MAX_PER
    page(params[:page].to_i).per(per)
  end
end
