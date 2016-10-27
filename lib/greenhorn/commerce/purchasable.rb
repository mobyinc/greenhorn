require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Purchasable < BaseModel
      def self.table
        'commerce_purchasables'
      end

      belongs_to :element, foreign_key: 'id', class_name: 'Greenhorn::Craft::Element'

      delegate :item, to: :element
    end
  end
end
