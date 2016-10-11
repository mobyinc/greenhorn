require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class FieldLayout < BaseModel
      has_one :entry_type, foreign_key: 'fieldLayoutId'
      has_many :attached_fields, class_name: 'FieldLayoutField', foreign_key: 'layoutId'
      has_many :tabs, class_name: 'FieldLayoutTab', foreign_key: 'layoutId'

      after_save do
        set_conditions(@conditions) if @conditions.present?
      end

      def self.table
        'fieldlayouts'
      end

      def default_tab
        tabs.first || tabs.create!(name: 'Content')
      end

      def add_field(field_or_handle, tab=nil)
        field = field_for(field_or_handle)
        raise "Couldn't find field with handle `#{field_or_handle}`" unless field.present?
        max_order = attached_fields.maximum(:sortOrder) || 0
        attached_fields.create!(field: field, tab: tab || default_tab, sortOrder: max_order + 1)
      end

      def remove_field(field_or_handle)
        attached_field = attached_fields.find_by(field: field_for(field_or_handle))
        raise "Couldn't find attached field with handle `#{field_or_handle}`" unless attached_field.present?
        attached_field.destroy
      end

      def field?(field_or_handle)
        field(field_or_handle).present?
      end

      def field(field_or_handle)
        attached_fields.find_by(field: field_for(field_or_handle))
      end

      def set_conditions(conditionals)
        Reasons::Reason.create_or_update(field_layout: self, conditionals: parsed_conditionals(conditionals))
      end

      def add_conditions(conditionals)
        Reasons::Reason.add_conditions(field_layout: self, conditionals: parsed_conditionals(conditionals))
      end

      def assign_attributes(attrs)
        @conditions = attrs.delete(:conditions)
        super(attrs)
      end

      private

      def field_for(field_or_handle)
        field = field_or_handle.is_a?(Field) ? field_or_handle : Field.find_by(handle: field_or_handle)
        raise Greenhorn::Errors::InvalidOperationError, "Field #{field_or_handle} doesn't exist" if field.nil?
        field
      end

      def parsed_conditionals(conditionals)
        conditionals = conditionals.map do |field_handle, condition_groups|
          host_field = field_for(field_handle)
          raise Greenhorn::Errors::InvalidOperationError,
            "Field #{host_field.handle} not attached to this field layout" unless field?(host_field)

          conditions = condition_groups.map do |condition_group|
            condition_group.map do |condition|
              conditional_field = field_for(condition[:field])
              raise Greenhorn::Errors::InvalidOperationError,
                "Field #{conditional_field.handle} not attached to this field layout" unless field?(conditional_field)

              if !condition[:equals].nil?
                compare = '=='
                value = condition[:equals]
              elsif !condition[:does_not_equal].nil?
                compare = '!='
                value = condition[:does_not_equal]
              end

              { fieldId: conditional_field.id, compare: compare, value: value.to_s }
            end
          end

          [host_field.id, conditions]
        end.to_h
      end
    end
  end
end
