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

      after_create do
        update(owner: Element.create!(type: 'MatrixBlock'))
      end
    end
  end
end
