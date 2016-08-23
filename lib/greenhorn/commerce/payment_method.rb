require 'greenhorn/commerce/base_model'
require 'safe_attributes'

module Greenhorn
  module Commerce
    class PaymentMethod < BaseModel
      include SafeAttributes::Base

      class << self
        # @!visibility private
        def table
          'commerce_paymentmethods'
        end

        # Creates a new payment method
        #
        # @param attrs [Hash]
        # @option attrs [String] class The Craft (PHP) class that implements this method
        # @option attrs [String] name
        # @option attrs [String<'authorize', 'purchase'>] paymentType ('purchase')
        # @option attrs [Boolean] frontendEnabled (false)
        # @option attrs [Boolean] isArchived (false)
        # @option attrs [DateTime] dateArchived (nil)
        # @option attrs [Integer] sortOrder (nil)
        # @return [PaymentMethod]
        #
        # @example Create a payment method
        #   PaymentMethod.create(name: 'Stripe', class: 'Stripe')
        def create(attrs)
          super(attrs)
        end
      end

      validates :paymentType,
                inclusion: { in: %w(authorize purchase), message: 'must be one of `authorize`, `purchase`' }

      # Updates an existing payment method
      #
      # @param attrs [Hash]
      # @option attrs [String] class The Craft (PHP) class that implements this method
      # @option attrs [String] name
      # @option attrs [String<'authorize', 'purchase'>] paymentType ('purchase')
      # @option attrs [Boolean] frontendEnabled (false)
      # @option attrs [Boolean] isArchived (false)
      # @option attrs [DateTime] dateArchived (nil)
      # @option attrs [Integer] sortOrder (nil)
      # @return [PaymentMethod]
      #
      # @example Create a payment method
      #   PaymentMethod.create(name: 'Stripe', class: 'Stripe')
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(class name))

        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing payment methdo
      #
      # @return [PaymentMethod]
      def destroy
        super
      end
    end
  end
end
