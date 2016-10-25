require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Product < BaseModel
      # @!visibility private
      def self.field_layout_association
        :type
      end
      include Craft::ContentBehaviors

      class << self
        # @!visibility private
        def table
          'commerce_products'
        end

        # Creates a new product
        #
        # @param attrs [Hash]
        # @option attrs [String] title The product's title
        # @option attrs [ProductType] type The product type this product belongs to
        # @option attrs [TaxCategory] tax_category (default tax category) The tax category to associate the product with
        # @option attrs [Boolean] promotable (true) Whether this product is promotable
        # @option attrs [Boolean] freeShipping (false) Whether this product is promotable
        # @option attrs [String] defaultSku The product's default SKU
        # @option attrs [Float] defaultPrice (null) The product's default price
        # @option attrs [Float] defaultHeight (null) The product's default price
        # @option attrs [Float] defaultLength (null) The product's default price
        # @option attrs [Float] defaultWidth (null) The product's default price
        # @option attrs [Float] defaultWeight (null) The product's default price
        # @option attrs [Hash] (...field_attrs) Values for any custom fields you've associated with the product type
        # @return [Product]
        #
        # @example Create a product using the product type's fields
        #   product_type = ProductType.create(name: 'Books', fields: Craft::Field.create(name: 'Description'))
        #   Product.create(title: 'Moby Dick', description: 'A story about a man and a whale')
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :type, class_name: 'ProductType', foreign_key: 'typeId'
      belongs_to :tax_category, foreign_key: 'taxCategoryId'
      belongs_to :default_variant, class_name: 'Variant', foreign_key: 'defaultVariantId'
      has_many :variants, foreign_key: 'productId', dependent: :destroy
      accepts_nested_attributes_for :default_variant

      validates :type, presence: true

      delegate :title, to: :element

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(type title defaultSku defaultPrice))

        default_variant_params = (attrs.delete(:default_variant_attrs) || {}).with_indifferent_access

        attrs[:promotable] = true if attrs[:promotable].nil?
        @slug = attrs[:slug].present? ? attrs[:slug] : Utility::Slug.new(attrs[:title])

        if attrs[:type].hasVariants
          default_variant_params[:isDefault] = true
          default_variant_params[:title] ||= attrs[:title]
          default_variant_params[:sku] ||= attrs[:defaultSku]
          default_variant_params[:price] ||= attrs[:defaultPrice]
          default_variant_params[:stock] ||= 0
          unlimited_stock =
            if default_variant_params[:unlimitedStock].nil?
              true
            else
              default_variant_params[:unlimitedStock]
            end
          default_variant_params[:unlimitedStock] = from_boolean(unlimited_stock)
          default_variant_params[:product] = self
          attrs[:default_variant_attributes] = default_variant_params
        end

        attrs[:tax_category] ||= TaxCategory.default

        attrs[:element] = Greenhorn::Craft::Element.new(slug: @slug, type: 'Commerce_Product')

        super(attrs)
      end

      # Updates an existing product
      #
      # @param attrs [Hash]
      # @option attrs [String] title The product's title
      # @option attrs [ProductType] type The product type this product belongs to
      # @option attrs [TaxCategory] tax_category (default tax category) The tax category to associate the product with
      # @option attrs [Boolean] promotable (true) Whether this product is promotable
      # @option attrs [Boolean] freeShipping (false) Whether this product is promotable
      # @option attrs [String] defaultSku The product's default SKU
      # @option attrs [Float] defaultPrice (null) The product's default price
      # @option attrs [Float] defaultHeight (null) The product's default price
      # @option attrs [Float] defaultLength (null) The product's default price
      # @option attrs [Float] defaultWidth (null) The product's default price
      # @option attrs [Float] defaultWeight (null) The product's default price
      # @option attrs [Hash] (...field_attrs) Values for any custom fields you've associated with the product type
      # @return [Product]
      def update(attrs)
        super(attrs)
      end

      # Removes an existing product
      #
      # @return [Product]
      def destroy
        super
      end

      # @!visibility private
      def add_neo_block(attrs)
        element.add_neo_block(attrs)
      end
    end
  end
end
