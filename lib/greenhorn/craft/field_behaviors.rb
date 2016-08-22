module Greenhorn
  module Craft
    module FieldBehaviors
      def self.included(base)
        base.class_eval do
          belongs_to :field_layout, class_name: 'Greenhorn::Craft::FieldLayout', foreign_key: 'fieldLayoutId'

          delegate :field?, to: :field_layout
          delegate :add_field, to: :field_layout
          delegate :remove_field, to: :field_layout

          after_create { assign_fields }
          after_update { assign_fields }
        end
      end

      def assign_fields
        (@fields || []).each do |field|
          add_field(field)
        end
      end

      def assign_attributes(attrs)
        @fields = attrs.delete(:fields)
        super(attrs)
      end

      def verify_fields_attached!(field_handles)
        field_handles = field_handles.map(&:to_s)
        attached_field_handles = field_layout.attached_fields.map(&:field).map(&:handle)
        field_handles.each do |field_handle|
          unless attached_field_handles.include?(field_handle)
            raise Greenhorn::Errors::InvalidOperationError, "Field `#{field_handle}` not attached to this resource"
          end
        end
      end
    end
  end
end
