require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Variant < BaseModel
      def self.table
        'commerce_variants'
      end

      include Craft::ContentBehaviors

      belongs_to :product, foreign_key: 'productId'
      belongs_to :element, foreign_key: 'id', class_name: 'Greenhorn::Craft::Element'

      delegate :title, to: :element

      after_create do
        Purchasable.create!(element: element, price: price, sku: sku)
      end

      def initialize(attrs)
        attrs = attrs.with_indifferent_access
        non_field_attrs = %w(title product).concat(self.class.column_names)
        field_attrs = attrs.reject { |key, _value| non_field_attrs.include?(key) }
        content_attrs = field_attrs.merge(title: attrs[:title])

        content_attrs.delete(:slug)
        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        element = Greenhorn::Craft::Element.create!(
          slug: slug,
          type: 'Commerce_Variant',
          content_attrs: content_attrs
        )

        sortOrder = attrs[:sortOrder] || attrs[:product].present? ? ((attrs[:product].variants.maximum(:sortOrder) || -1) + 1) : 0

        super(
          id: element.id,
          isDefault: from_boolean(attrs[:isDefault]),
          price: attrs[:price],
          sku: attrs[:sku],
          stock: attrs[:stock],
          unlimitedStock: attrs[:unlimitedStock],
          product: attrs[:product],
          sortOrder: sortOrder
        )
      end

      def field_layout
        product.type.variant_field_layout
      end
    end
  end
end
