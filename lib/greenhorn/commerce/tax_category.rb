require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxCategory < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_taxcategories'
        end

        # Finds the default tax category, if any
        #
        # @return [TaxCategory]
        def default
          find_by(default: 1)
        end

        # Creates a new tax category
        #
        # @param attrs [Hash]
        # @option attrs [String] name The category's name
        # @option attrs [String] handle (inferred) The category's slug
        # @option attrs [String] description (nil) The category's description
        # @option attrs [Boolean] default (false) Whether this should be set as the default tax category
        # @return [TaxCategory]
        #
        # @example Create a new default tax category
        #   TaxCategory.create(name: 'New default', default: true)
        def create(attrs)
          super(attrs)
        end
      end

      after_save do
        if default
          TaxCategory.where(default: true).where.not(id: id).update_all(default: false)
        end
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(name))
        attrs[:handle] ||= Utility::Handle.new(attrs[:name])

        super(attrs)
      end

      # Updates an existing tax category
      #
      # @param attrs [Hash]
      # @option attrs [String] name The category's name
      # @option attrs [String] handle (inferred) The category's slug
      # @option attrs [String] description (nil) The category's description
      # @option attrs [Boolean] default (false) Whether this should be set as the default tax category
      # @return [TaxCategory]
      def update(attrs)
        super(attrs)
      end

      # Removes an existing tax category
      #
      # @return [TaxCategory]
      def destroy
        super
      end
    end
  end
end
