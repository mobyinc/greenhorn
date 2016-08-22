require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Address < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_addresses'
        end

        # Creates a new address
        #
        # @param attrs [Hash]
        # @option attrs [String] firstName
        # @option attrs [String] lastName
        # @option attrs [Country] country (nil)
        # @option attrs [State] state (nil)
        # @option attrs [String] address1 (nil)
        # @option attrs [String] address2 (nil)
        # @option attrs [String] city (nil)
        # @option attrs [String] zipCode (nil)
        # @option attrs [String] phone (nil)
        # @option attrs [String] alternativePhone (nil)
        # @option attrs [String] businessName (nil)
        # @option attrs [String] businessTaxId (nil)
        # @option attrs [String] stateName (nil)
        # @return [Address]
        #
        # @example Create an address
        #   Address.create!(firstName: 'Jane', lastName: 'Doe')
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :state, foreign_key: 'stateId', class_name: 'State'
      belongs_to :country, foreign_key: 'countryId', class_name: 'Country'

      # Updates an existing address
      #
      # @param attrs [Hash]
      # @option attrs [String] firstName
      # @option attrs [String] lastName
      # @option attrs [Country] country (nil)
      # @option attrs [State] state (nil)
      # @option attrs [String] address1 (nil)
      # @option attrs [String] address2 (nil)
      # @option attrs [String] city (nil)
      # @option attrs [String] zipCode (nil)
      # @option attrs [String] phone (nil)
      # @option attrs [String] alternativePhone (nil)
      # @option attrs [String] businessName (nil)
      # @option attrs [String] businessTaxId (nil)
      # @option attrs [String] stateName (nil)
      # @return [Address]
      #
      # @example Create an address
      #   Address.create!(firstName: 'Jane', lastName: 'Doe')
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(firstName lastName))

        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing address
      #
      # @return [Address]
      def destroy
        super
      end
    end
  end
end
