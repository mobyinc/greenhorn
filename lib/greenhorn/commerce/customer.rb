require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Customer < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_customers'
        end

        # Creates a new customer
        #
        # @param attrs [Hash]
        # @option attrs [User] user (nil) A regular Craft user to associate this customer with
        # @option attrs [String] email (nil)
        # @option attrs [Address] last_used_billing_address (nil)
        # @option attrs [Address] last_used_shipping_address (nil)
        # @return [Customer]
        #
        # @example Create a customer from a Craft user
        #   Customer.create!(user: Craft::User.last)
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :user, foreign_key: 'userId', class_name: 'Craft::User'
      belongs_to :last_used_billing_address, foreign_key: 'lastUsedBillingAddressId', class_name: 'Address'
      belongs_to :last_used_shipping_address, foreign_key: 'lastUsedShippingAddressId', class_name: 'Address'

      # Updates an existing customer
      #
      # @param attrs [Hash]
      # @option attrs [User] user (nil) A regular Craft user to associate this customer with
      # @option attrs [String] email (nil)
      # @option attrs [Address] last_used_billing_address (nil)
      # @option attrs [Address] last_used_shipping_address (nil)
      # @return [Customer]
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing customer
      #
      # @return [Customer]
      def destroy
        super
      end
    end
  end
end
