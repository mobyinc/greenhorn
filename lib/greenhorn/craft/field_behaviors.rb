module Greenhorn
  module Craft
    module FieldBehaviors
      def self.included(base)
        base.class_eval do
          belongs_to :field_layout, class_name: 'Greenhorn::Craft::FieldLayout', foreign_key: 'fieldLayoutId'
          has_many :attached_fields, through: :field_layout
          has_many :fields, through: :attached_fields

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

      def verify_fields_attached!(handles)
        handles = field_handles.map(&:to_s)
        handles.each do |handle|
          unless field_handles.include?(handle)
            raise Greenhorn::Errors::InvalidOperationError, "Field `#{handle}` not attached to this resource"
          end
        end
      end

      def field_handles
        fields.map(&:handle)
      end
    end
  end
end
