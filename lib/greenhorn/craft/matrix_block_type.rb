require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class MatrixBlockType < BaseModel
      def self.table
        'matrixblocktypes'
      end

      belongs_to :field, foreign_key: 'fieldId'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId'
      has_many :blocks, foreign_key: 'typeId', class_name: 'MatrixBlock'

      after_create do
        field_layout = FieldLayout.create!(type: 'MatrixBlock')
        @attrs[:fields].each do |field|
          field = Field.create!(field.merge(context: "matrixBlockType:#{id}"))
          field_layout.add_field(field)
        end
        update(field_layout: field_layout)
      end

      def initialize(attrs)
        attrs[:handle] ||= Utility::Handle.new(attrs[:name])
        @attrs = attrs.dup
        attrs.delete(:fields)
        super(attrs)
      end
    end
  end
end
