require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class EntryType < BaseModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId'

      def self.table
        'entrytypes'
      end

      before_create do
        self.field_layout = FieldLayout.create!(type: 'Entry')
      end
    end
  end
end