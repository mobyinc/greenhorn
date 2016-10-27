require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class LineItem < BaseModel
      class << self
        def table
          'commerce_lineitems'
        end
      end

      belongs_to :order, foreign_key: 'orderId'
      belongs_to :purchasable, foreign_key: 'purchasableId', class_name: 'Purchasable'

      delegate :sku, to: :purchasable
    end
  end
end
