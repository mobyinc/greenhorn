require 'greenhorn/craft/base_model'

module Greenhorn
  module Neo
    class BlockType < BaseModel
      def self.table
        'neoblocktypes'
      end

      belongs_to :owner, foreign_key: 'ownerId', class_name: 'Craft::Element'
      belongs_to :field, foreign_key: 'fieldId', class_name: 'Craft::Field'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId', class_name: 'Craft::FieldLayout'
      has_many :blocks, foreign_key: 'typeId', class_name: 'NeoBlockType'

      serialize :childBlocks, JSON

      after_create do
        field_layout = Craft::FieldLayout.create!(type: 'Neo_Block')

        (@attrs[:fields] || []).each do |field|
          field_layout.add_field(field)
        end

        field_layout.set_conditions(@conditions) if @conditions.present?
        update(field_layout: field_layout, sortOrder: next_sort_order)
      end

      after_update do
        field_layout.set_conditions(@conditions) if @conditions.present?
      end

      def initialize(attrs)
        attrs[:handle] ||= Utility::Handle.new(attrs[:name])
        @attrs = attrs.dup
        attrs.delete(:fields)
        attrs[:topLevel] = from_boolean(attrs[:topLevel])
        super(attrs)
      end

      def add_child(block)
        new_child_blocks = (childBlocks || []) << block.handle
        update!(childBlocks: new_child_blocks.uniq)
      end

      def remove_child(block)
        update!(childBlocks: childBlocks.delete_if { |handle| handle == block.handle })
      end

      def assign_attributes(attrs)
        @conditions = attrs.delete(:conditions) if attrs[:conditions].present?
        super(attrs)
      end
    end
  end
end
