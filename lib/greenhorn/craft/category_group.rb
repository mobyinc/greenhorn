require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class CategoryGroup < BaseModel
      include Craft::FieldBehaviors

      def self.table
        'categorygroups'
      end

      has_many :categories, foreign_key: 'groupId'
      belongs_to :structure, foreign_key: 'structureId'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId'

      before_create do
        self.structure = Structure.create!
        self.field_layout = FieldLayout.create!(type: 'Category')
        self.handle = Utility::Handle.new(name)
      end
      after_create do
        root_element = StructureElement.create(structure: structure, lft: 1, rgt: 2, level: 0)
        root_element.update(root: root_element)
      end
    end
  end
end
