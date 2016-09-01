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

      after_destroy do
        content.destroy
      end

      def element
        Element.find(id)
      end

      def content_model
        MatrixContent.model_class_for(type.field.handle)
      end

      def content
        content_model.find_by(element: self)
      end

      def content_attributes
        content.field_values
      end
    end
  end
end
