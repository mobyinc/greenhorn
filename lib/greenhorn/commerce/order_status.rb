require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class OrderStatus < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_orderstatuses'
        end

        # Creates a new order status
        #
        # @param attrs [Hash]
        # @option attrs [String] name
        # @option attrs [String] handle (inferred from name)
        # @option attrs [String<'green','orange','red','blue','yellow','pink','purple','turquoise','light','grey','black'>] color ('green')
        # @option attrs [Integer] sortOrder
        # @option attrs [Boolean] default (false)
        # @return [OrderStatus]
        #
        # @example Create an order status
        #   OrderStatus.create!(name: 'Backordered')
        def create(attrs = {})
          super(attrs)
        end

        def default
          find_by(default: true)
        end
      end

      validates :handle, :name, presence: true

      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        if attrs[:name].present?
          attrs[:handle] ||= Utility::Handle.new(attrs[:name])
        end

        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing order status
      #
      # @return [OrderStatus]
      def destroy
        super
      end
    end
  end
end
