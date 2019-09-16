class Search::Base
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :order, :asc, :desc
end
