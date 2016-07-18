require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class MatrixBlock < BaseModel
      def self.table
        'matrixblocks'
      end

      belongs_to :owner, foreign_key: 'ownerId', class_name: 'Element'
      belongs_to :field, foreign_key: 'fieldId'
      belongs_to :type, foreign_key: 'typeId', class_name: 'MatrixBlockType'

      before_create do
        self.id = Element.create!(type: 'MatrixBlock').id
        self.sortOrder = 1
        self.ownerLocale = 'en_us'
      end

      def element
        Element.find(id)
      end
    end
  end
end
