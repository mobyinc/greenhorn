require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Variant < BaseModel
      def self.table
        'commerce_variants'
      end

      belongs_to :product, foreign_key: 'productId'

      def initialize(attrs)
        non_field_attrs = %w(title product).concat(self.class.column_names)
        field_attrs = attrs
                      .reject { |key, _value| non_field_attrs.include?(key) }
                      .map { |key, value| ["field_#{key}", value] }.to_h
        content_attrs = field_attrs.merge(title: attrs[:title])

        element = Greenhorn::Craft::Element.create!(
          type: 'Commerce_Variant',
          content: Greenhorn::Craft::Content.new(content_attrs)
        )

        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        Greenhorn::Craft::ElementLocale.create!(
          element: element,
          slug: slug,
          locale: 'en_us'
        )

        super(
          id: element.id,
          isDefault: from_boolean(attrs[:isDefault]),
          price: attrs[:price],
          sku: attrs[:sku],
          stock: attrs[:stock],
          unlimitedStock: attrs[:unlimitedStock],
          product: attrs[:product]
        )
      end
    end
  end
end
