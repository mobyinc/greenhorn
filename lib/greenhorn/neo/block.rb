require 'greenhorn/craft/base_model'

module Greenhorn
  module Neo
    class Block < BaseModel
      def self.table
        'neoblocks'
      end

      belongs_to :element, foreign_key: 'id', class_name: 'Craft::Element'
      belongs_to :owner, foreign_key: 'ownerId', class_name: 'Craft::Element'
      belongs_to :type, foreign_key: 'typeId', class_name: 'BlockType'
      belongs_to :field, foreign_key: 'fieldId', class_name: 'Craft::Field'

      after_create do
        Craft::StructureElement.create!(structure: @structure.structure, element: element, parent: @parent, root: @root)
      end

      def initialize(attrs)
        @structure = attrs.delete(:structure)
        @parent = attrs.delete(:parent)
        @root = attrs.delete(:root)
        non_field_attrs = %i(field type).concat(self.class.column_names.map(&:to_sym))
        field_attrs = attrs.reject { |key, _value| non_field_attrs.include?(key) }
        field_attrs.each { |key, _value| attrs.delete(key) }

        attrs[:element] = Craft::Element.create!(
          type: 'Neo_Block',
          content: Craft::Content.new(field_attrs)
        )

        super(attrs)
      end
    end
  end
end
