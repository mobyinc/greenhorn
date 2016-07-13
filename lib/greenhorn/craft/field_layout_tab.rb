require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class FieldLayoutTab < BaseModel
      belongs_to :field_layout, foreign_key: 'layoutId'

      def self.table
        'fieldlayouttabs'
      end
    end
  end
end
