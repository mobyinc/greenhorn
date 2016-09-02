require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class FieldLayout < BaseModel
      has_one :entry_type, foreign_key: 'fieldLayoutId'
      has_many :attached_fields, class_name: 'FieldLayoutField', foreign_key: 'layoutId'
      has_many :tabs, class_name: 'FieldLayoutTab', foreign_key: 'layoutId'

      def self.table
        'fieldlayouts'
      end

      def default_tab
        tabs.first || tabs.create!(name: 'Tab 1')
      end

      def add_field(field_or_handle)
        field = field_for(field_or_handle)
        raise "Couldn't find field with handle `#{field_or_handle}`" unless field.present?
        max_order = attached_fields.maximum(:sortOrder) || 0
        attached_fields.create!(field: field, tab: default_tab, sortOrder: max_order + 1)
      end

      def remove_field(field_or_handle)
        attached_field = attached_fields.find_by(field: field_for(field_or_handle))
        raise "Couldn't find attached field with handle `#{field_or_handle}`" unless attached_field.present?
        attached_field.destroy
      end

      def field?(field_or_handle)
        attached_fields.find_by(field: field_for(field_or_handle)).present?
      end

      private

      def field_for(field_or_handle)
        field_or_handle.is_a?(Field) ? field_or_handle : Field.find_by(handle: field_or_handle)
      end
    end
  end
end
