require 'greenhorn/craft/base_model'

module Greenhorn
  module Neo
    class Group < BaseModel
      def self.table
        'neogroups'
      end

      belongs_to :field, foreign_key: 'fieldId', class_name: 'Craft::Field'

      after_create do
        update(sortOrder: next_sort_order)

        (@attrs[:block_types] || []).each do |block_type|
          field.neo_block_types.create!(block_type)
        end
      end

      def initialize(attrs)
        @attrs = attrs.dup
        attrs.delete(:block_types)
        super(attrs)
      end
    end
  end
end
