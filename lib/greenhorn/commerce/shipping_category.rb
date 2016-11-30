require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class ShippingCategory < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_shippingcategories'
        end

        def default
          find_by(default: 1)
        end

        def create(attrs)
          super(attrs)
        end
      end

      after_save do
        if default
          ShippingCategory.where(default: true).where.not(id: id).update_all(default: false)
        end
      end

      def initialize(attrs)
        require_attributes!(attrs, %i(name))
        attrs[:handle] ||= Utility::Handle.new(attrs[:name])

        super(attrs)
      end

      def update(attrs)
        super(attrs)
      end

      def destroy
        super
      end
    end
  end
end
