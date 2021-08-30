module Search
  class Base
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :order, :direction, :page, :per
  end
end
