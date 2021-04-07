require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Variant < BaseModel
      # def self.field_layout_association
      #   :type
      # end
      def self.table
        'commerce_variants'
      end
      include Craft::ContentBehaviors

      belongs_to :product, foreign_key: 'productId'
      has_one :type, through: :product
      belongs_to :element, foreign_key: 'id', class_name: 'Greenhorn::Craft::Element'

      delegate :title, to: :element

      after_create do
        Purchasable.create!(element: element, price: price, sku: sku)
      end

      def assign_attributes(attrs)
        if element.nil?
          slug = attrs[:slug]
          attrs[:element] = Greenhorn::Craft::Element.create!(
            slug: slug,
            type: 'Commerce_Variant',
            content: Greenhorn::Craft::Content.new(locale: 'en_us')
          )
          attrs.delete(:slug)
        end

        # attrs[:sortOrder] = attrs[:sortOrder] || attrs[:product].present? ? ((attrs[:product].variants.maximum(:sortOrder) || -1) + 1) : 0
        super(attrs)
      end

      def field_layout
        product.type.variant_field_layout
      end

      def verify_fields_attached?
        false
      end
    end
  end
end
