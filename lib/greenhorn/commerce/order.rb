require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Order < BaseModel
      # @!visibility private
      def self.field_layout_parent
        :order_setting
      end
      include Craft::ContentBehaviors

      class << self
        delegate :add_field, to: :order_setting
        delegate :remove_field, to: :order_setting
        delegate :field?, to: :order_setting

        # @!visibility private
        def table
          'commerce_orders'
        end

        # Creates a new order
        #
        # @param attrs [Hash]
        # @option attrs [Address] billing_address (nil) The order's billing address
        # @option attrs [Address] shipping_address (nil) The order's billing address
        # @option attrs [PaymentMethod] payment_method (nil) The order's payment method
        # @option attrs [Customer] customer (nil) The order's customer
        # @option attrs [OrderStatus] status (OrderStatus.default) The order's status
        # @option attrs [String] number (32-character hex) The order number
        # @option attrs [String] couponCode (nil)
        # @option attrs [Float] itemTotal (0)
        # @option attrs [Float] baseDiscount (0)
        # @option attrs [Float] baseShippingCost (0)
        # @option attrs [Float] totalPrice (0)
        # @option attrs [Float] totalPaid (0)
        # @option attrs [String] email (nil)
        # @option attrs [Boolean] isCompleted (false)
        # @option attrs [DateTime] dateOrdered (nil)
        # @option attrs [DateTime] datePaid (nil)
        # @option attrs [String] currency (nil)
        # @option attrs [String] lastIp (nil)
        # @option attrs [String] message (nil)
        # @option attrs [String] returnUrl (nil)
        # @option attrs [String] cancelUrl (nil)
        # @option attrs [String] shippingMethod (nil)
        # @return [Order]
        #
        # @example Create an order with a customer and address
        #   Order.create(customer: Customer.create!(email: 'ahab@mobyinc.com'))
        def create(attrs)
          super(attrs)
        end

        private

        def order_setting
          OrderSetting.first
        end
      end

      belongs_to :billing_address, foreign_key: 'billingAddressId', class_name: 'Address'
      belongs_to :shipping_address, foreign_key: 'shippingAddressId', class_name: 'Address'
      belongs_to :payment_method, foreign_key: 'paymentMethodId', class_name: 'PaymentMethod'
      belongs_to :customer, foreign_key: 'customerId', class_name: 'Customer'
      belongs_to :status, foreign_key: 'orderStatusId', class_name: 'OrderStatus'
      has_many :histories, foreign_key: 'orderId', class_name: 'OrderHistory'

      before_create do
        create_element(type: 'Order')
      end

      # Updates an existing order
      #
      # @param attrs [Hash]
      # @option attrs [Address] billing_address (nil) The order's billing address
      # @option attrs [Address] shipping_address (nil) The order's billing address
      # @option attrs [PaymentMethod] payment_method (nil) The order's payment method
      # @option attrs [Customer] customer (nil) The order's customer
      # @option attrs [OrderStatus] status (OrderStatus.default) The order's status
      # @option attrs [String] number (32-character hex) The order number
      # @option attrs [String] couponCode (nil)
      # @option attrs [Float] itemTotal (0)
      # @option attrs [Float] baseDiscount (0)
      # @option attrs [Float] baseShippingCost (0)
      # @option attrs [Float] totalPrice (0)
      # @option attrs [Float] totalPaid (0)
      # @option attrs [String] email (nil)
      # @option attrs [Boolean] isCompleted (false)
      # @option attrs [DateTime] dateOrdered (nil)
      # @option attrs [DateTime] datePaid (nil)
      # @option attrs [String] currency (nil)
      # @option attrs [String] lastIp (nil)
      # @option attrs [String] message (nil)
      # @option attrs [String] returnUrl (nil)
      # @option attrs [String] cancelUrl (nil)
      # @option attrs [String] shippingMethod (nil)
      # @return [Order]
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

      # Removes an existing order
      #
      # @return [Order]
      def destroy
        super
      end

      private

      def order_setting
        self.class.send(:order_setting)
      end
    end
  end
end
