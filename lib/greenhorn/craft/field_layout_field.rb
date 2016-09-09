require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class FieldLayoutField < BaseModel
      belongs_to :field_layout, foreign_key: 'layoutId'
      belongs_to :tab, class_name: 'FieldLayoutTab', foreign_key: 'tabId'
      belongs_to :field, foreign_key: 'fieldId'

      delegate :handle, :name, :type, to: :field, prefix: true

      def self.table
        'fieldlayoutfields'
      end
    end
  end
end
