require 'greenhorn/commerce/base_model'
require 'greenhorn/craft/field_behaviors'

module Greenhorn
  module Commerce
    class OrderSetting < BaseModel
      include Craft::FieldBehaviors

      class << self
        # @!visibility private
        def table
          'commerce_ordersettings'
        end

        def create(attrs)
          super(attrs)
        end
      end

      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        attrs ||= {}
        attrs[:status] ||= OrderStatus.default

        # TODO: Is this how Craft really assigns order numbers?
        attrs[:number] ||= SecureRandom.hex(16)

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
    end
  end
end
