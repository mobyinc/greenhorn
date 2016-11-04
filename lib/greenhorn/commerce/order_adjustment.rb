require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class OrderAdjustment < BaseModel
      class << self
        def table
          'commerce_orderadjustments'
        end
      end

      belongs_to :order, foreign_key: 'orderId', class_name: 'Order'
    end
  end
end
