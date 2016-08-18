require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxRate < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_taxrates'
        end

        # Creates a new tax rate
        #
        # @param attrs [Hash]
        # @option attrs [String] name The tax rate's name
        # @option attrs [TaxCategory] tax_category (default tax category) The tax category to associate the rate with
        # @option attrs [TaxZone] tax_zone The tax zone to associate the rate with
        # @option attrs [Float] rate (0.05) The tax rate percentage
        # @option attrs [Boolean] include (false) Whether to include the tax rate in the price
        #   (only available if using the default tax zone)
        # @option attrs [Boolean] showInLabel (false) Whether to show the tax rate in the label
        # @option attrs ['price', 'shipping', 'price_shipping'] taxable ('price')
        #   The subject that should be taxable using this rate
        # @return [TaxRate]
        #
        # @example Create a tax rate using the default category
        #   TaxRate.create(name: 'Seattle Sales Tax', rate: 0.0975, include: true, tax_zone: TaxZone.default)
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :tax_zone, foreign_key: 'taxZoneId', class_name: 'TaxZone'
      belongs_to :tax_category, foreign_key: 'taxCategoryId', class_name: 'TaxCategory'

      validates :taxable, inclusion: { in: %w(price shipping price_shipping) }
      validate :include_is_valid

      # Updates an existing tax rate
      #
      # @param attrs [Hash]
      # @option attrs [String] name The tax rate's name
      # @option attrs [TaxCategory] tax_category (default tax category) The tax category to associate the rate with
      # @option attrs [TaxZone] tax_zone The tax zone to associate the rate with
      # @option attrs [Float] rate (0.05) The tax rate percentage
      # @option attrs [Boolean] include (false) Whether to include the tax rate in the price
      #   (only available if using the default tax zone)
      # @option attrs [Boolean] showInLabel (false) Whether to show the tax rate in the label
      # @option attrs ['price', 'shipping', 'price_shipping'] taxable ('price')
      #   The subject that should be taxable using this rate
      # @return [TaxRate]
      #
      # @example Update a tax rate's zone
      #   tax_rate.update(tax_zone: new_tax_zone)
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(name tax_zone))
        attrs[:tax_category] ||= TaxCategory.default
        attrs[:rate] ||= 0.05
        attrs[:taxable] ||= 'price'

        if attrs[:tax_category].nil?
          raise Greenhorn::Errors::MissingAttributeError, 'You must pass a tax category if there is no default'
        end

        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing tax rate
      #
      # @return [TaxRate]
      def destroy
        super
      end

      private

      def include_is_valid
        if tax_zone.present? && !tax_zone.default && include
          errors.add(:include, 'can only be set if using the default tax zone')
        end
      end
    end
  end
end
