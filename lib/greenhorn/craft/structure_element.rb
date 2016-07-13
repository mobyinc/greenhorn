require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class StructureElement < BaseModel
      def self.table
        'structureelements'
      end

      belongs_to :element, foreign_key: 'elementId'
      belongs_to :structure, foreign_key: 'structureId'
    end
  end
end
