require 'greenhorn/craft/base_model'

module Greenhorn
  module Neo
    class BlockStructure < BaseModel
      def self.table
        'neoblockstructures'
      end

      belongs_to :owner, foreign_key: 'ownerId', class_name: 'Craft::Element'
      belongs_to :field, foreign_key: 'fieldId', class_name: 'Craft::Field'
      belongs_to :structure, foreign_key: 'structureId', class_name: 'Craft::Structure'

      delegate :root_element, to: :structure

      before_create do
        self.structure = Craft::Structure.create!
        Craft::StructureElement.create!(structure: structure, lft: 1, rgt: 2, level: 0)
      end
    end
  end
end
