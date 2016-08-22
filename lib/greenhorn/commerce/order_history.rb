require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class OrderHistory < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_orderhistories'
        end

        # Creates a new order history item
        #
        # @param attrs [Hash]
        # @option attrs [Order] order
        # @option attrs [Customer] customer
        # @option attrs [OrderStatus] previous_status (nil)
        # @option attrs [OrderStatus] new_status (nil)
        # @option attrs [String] message (nil)
        # @return [OrderHistory]
        #
        # @example Create an order history item
        #   OrderHistory.create!(order: Order.last, customer: Order.last.customer)
        def create(attrs)
          super(attrs)
        end
      end

      belongs_to :order, foreign_key: 'orderId', class_name: 'Order'
      belongs_to :customer, foreign_key: 'customerId', class_name: 'Customer'
      belongs_to :previous_status, foreign_key: 'prevStatusId', class_name: 'OrderStatus'
      belongs_to :new_status, foreign_key: 'newStatusId', class_name: 'OrderStatus'

      validates :customer, :order, presence: true

      # Updates an existing order history item
      #
      # @param attrs [Hash]
      # @option attrs [Order] order
      # @option attrs [Customer] customer
      # @option attrs [OrderStatus] previous_status (nil)
      # @option attrs [OrderStatus] new_status (nil)
      # @option attrs [String] message (nil)
      # @return [OrderHistory]
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

      # Removes an existing order history
      #
      # @return [OrderHistory]
      def destroy
        super
      end
    end
  end
end
