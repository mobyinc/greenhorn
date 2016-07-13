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

      def attach_field(field_or_handle)
        field = field_or_handle.is_a?(Field) ? field_or_handle : Field.find_by(handle: field_or_handle)
        raise "Couldn't find field with handle `#{field_or_handle}`" unless field.present?
        attached_fields.create!(field: field, tab: default_tab)
      end
    end
  end
end
