require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Product < BaseModel
      def self.table
        'commerce_products'
      end

      belongs_to :element, foreign_key: 'id', class_name: 'Craft::Element'
      belongs_to :type, class_name: 'ProductType', foreign_key: 'typeId'
      belongs_to :tax_category, foreign_key: 'taxCategoryId'
      belongs_to :default_variant, class_name: 'Variant', foreign_key: 'defaultVariantId'
      has_one :element_locale, through: :element
      has_many :variants, foreign_key: 'productId', dependent: :destroy
      accepts_nested_attributes_for :default_variant

      validates :type, presence: true

      def initialize(attrs)
        non_field_attrs = %i(title type tax_category).concat(self.class.column_names.map(&:to_sym))
        field_attrs = attrs.reject { |key, _value| non_field_attrs.include?(key) }
        attrs[:type].verify_fields_attached!(field_attrs.keys)

        field_attrs.each { |key, _value| attrs.delete(key) }
        content_attrs = field_attrs.merge(title: attrs[:title])

        slug = attrs[:slug].present? ? attrs[:slug] : Utility::Slug.new(attrs[:title])
        element = Greenhorn::Craft::Element.create!(
          slug: slug,
          type: 'Commerce_Product',
          content: Greenhorn::Craft::Content.new(content_attrs)
        )

        default_variant_params = attrs[:default_variant_params] || {}
        default_variant_params[:isDefault] = true
        default_variant_params[:title] ||= attrs[:title]
        default_variant_params[:sku] ||= attrs[:defaultSku]
        default_variant_params[:price] ||= attrs[:defaultPrice]
        default_variant_params[:stock] ||= 0
        unlimited_stock = default_variant_params[:unlimitedStock] || true
        default_variant_params[:unlimitedStock] = from_boolean(unlimited_stock)
        default_variant_params[:product] = self

        attrs[:default_variant_attributes] = default_variant_params
        attrs[:tax_category] ||= TaxCategory.default
        attrs[:id] = element.id
        attrs.delete(:title)

        super(attrs)
      end

      def add_neo_block(attrs)
        element.add_neo_block(attrs)
      end
    end
  end
end
