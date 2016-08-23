require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class ProductType < BaseModel
      include Craft::FieldBehaviors

      # @!visibility private
      class << self
        def table
          'commerce_producttypes'
        end

        # Creates a new product type
        #
        # @param attrs [Hash]
        # @option attrs [String] name The product type's name
        # @option attrs [String] handle (inferred) The product type's handle (auto-generated from `name` if not passed)
        # @option attrs [Boolean] hasUrls (false) Whether this product type's products have URLs
        # @option attrs [Boolean] hasDimensions (false) Whether this product type's products have dimensions
        # @option attrs [Boolean] hasVariants (false) Whether this product type's products have variants
        # @option attrs [Boolean] hasVariantTitleField (false) Whether this product type's products' variants
        #   have their own titles
        # @option attrs [Array<Craft::Field>] fields ([]) The fields to associate with this product type
        # @return [ProductType]
        #
        # @example Create a product type with fields
        #   ProductType.create(name: 'Books', fields: Craft::Field.create(name: 'Description'))
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :variant_field_layout, class_name: 'Greenhorn::Craft::FieldLayout', foreign_key: 'variantFieldLayoutId'

      before_create do
        self.handle = Utility::Slug.new(name) unless handle.present?
        self.titleFormat = '{product.title}' unless titleFormat.present?
        self.field_layout = Greenhorn::Craft::FieldLayout.create!(type: 'Commerce_Product')

        if hasVariants
          self.variant_field_layout = Greenhorn::Craft::FieldLayout.create!(type: 'Commerce_Variant')
        end
      end

      after_create do
        if @variant_fields.present?
          @variant_fields.each do |field|
            add_variant_field(field)
          end
        end
      end

      # Attaches a field to the product type's variant field list
      def add_variant_field(field)
        variant_field_layout.attach_field(field)
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(name))

        attrs[:hasVariants] = false if attrs[:hasVariants].nil?
        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        @variant_fields = attrs[:variant_fields]
        attrs.delete(:variant_fields)

        super(attrs)
      end

      # Updates an existing product type
      #
      # @param attrs [Hash]
      # @option attrs [String] name The product type's name
      # @option attrs [String] handle (inferred) The product type's handle (auto-generated from `name` if not passed)
      # @option attrs [Boolean] hasUrls (false) Whether this product type's products have URLs
      # @option attrs [Boolean] hasDimensions (false) Whether this product type's products have dimensions
      # @option attrs [Boolean] hasVariants (false) Whether this product type's products have variants
      # @option attrs [Boolean] hasVariantTitleField (false) Whether this product type's products' variants
      #   have their own titles
      # @option attrs [Array<Craft::Field>] fields ([]) The fields to associate with this product type
      # @return [ProductType]
      def update(attrs)
        super(attrs)
      end

      # Removes an existing product type
      #
      # @return [ProductType]
      def destroy
        super
      end
    end
  end
end
