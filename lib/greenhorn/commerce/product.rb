require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Product < BaseModel
      def self.table
        'commerce_products'
      end

      belongs_to :element, foreign_key: 'id'
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

        asset_fields, regular_fields = field_attrs.partition do |field_handle, _value|
          field = Greenhorn::Craft::Field.find_by(handle: field_handle)
          field.type == 'Assets'
        end.map(&:to_h)

        field_attrs.each { |key, _value| attrs.delete(key) }
        field_attrs = regular_fields.map { |key, value| ["field_#{key}", value] }.to_h
        content_attrs = field_attrs.merge(title: attrs[:title])

        element = Greenhorn::Craft::Element.create!(
          type: 'Commerce_Product',
          content: Greenhorn::Craft::Content.new(content_attrs)
        )

        asset_fields.each do |handle, value|
          field = Greenhorn::Craft::Field.find_by(handle: handle)
          asset_source = Greenhorn::Craft::AssetSource.find(field.settings['defaultUploadLocationSource'].to_i)

          value = [value] unless value.is_a?(Array)
          value.each do |file|
            asset_file = Greenhorn::Craft::AssetFile.create!(
              file: file,
              kind: 'image',
              asset_source: asset_source,
              asset_folder: asset_source.asset_folder
            )
            Greenhorn::Craft::Relation.create!(field: field, source: element, target: asset_file.element)
          end
        end

        slug = attrs[:slug].present? ? attrs[:slug] : Utility::Slug.new(attrs[:title])
        Greenhorn::Craft::ElementLocale.create!(element: element, slug: slug, locale: 'en_us')

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
    end
  end
end
