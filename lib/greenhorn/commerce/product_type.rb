require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class ProductType < BaseModel
      def self.table
        'commerce_producttypes'
      end

      belongs_to :field_layout, class_name: 'Greenhorn::Craft::FieldLayout', foreign_key: 'fieldLayoutId'
      belongs_to :variant_field_layout, class_name: 'Greenhorn::Craft::FieldLayout', foreign_key: 'variantFieldLayoutId'

      before_create do
        self.handle = Utility::Slug.new(name) unless handle.present?
        self.titleFormat = '{product.title}' unless titleFormat.present?
        self.field_layout = Greenhorn::Craft::FieldLayout.create!(type: 'Commerce_Product')
        self.variant_field_layout = Greenhorn::Craft::FieldLayout.create!(type: 'Commerce_Variant')
      end

      after_create do
        if @fields.present?
          @fields.each do |field|
            add_field(field)
          end
        end
      end

      def add_field(field)
        field_layout.attach_field(field)
      end

      def verify_fields_attached!(field_handles)
        field_handles = field_handles.map(&:to_s)
        attached_field_handles = field_layout.attached_fields.map(&:field).map(&:handle)
        field_handles.each do |field_handle|
          raise "Field `#{field_handle}` not attached to this product type" unless attached_field_handles.include?(field_handle)
        end
      end

      def initialize(attrs)
        attrs[:hasVariants] = from_boolean(attrs[:hasVariants] || false)
        @fields = attrs[:fields]
        attrs.delete(:fields)
        super(attrs)
      end
    end
  end
end
