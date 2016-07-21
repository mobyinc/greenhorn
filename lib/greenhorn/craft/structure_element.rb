require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class StructureElement < BaseModel
      def self.table
        'structureelements'
      end

      belongs_to :element, foreign_key: 'elementId'
      belongs_to :structure, foreign_key: 'structureId'
      belongs_to :root, foreign_key: 'root', class_name: 'StructureElement'

      def child_elements
        structure.structure_elements.where("level > #{level} AND lft > #{lft} AND rgt < #{rgt}")
      end

      def parent
        return nil if level == 0
        structure.structure_elements.where(level: level - 1).where("lft < #{lft} AND rgt > #{rgt}").first
      end

      def initialize(attrs)
        @parent = attrs.delete(:parent)
        if @parent.present?
          attrs[:root] = @parent.root
          attrs[:level] = @parent.level + 1
          attrs[:structure] = @parent.structure
          subtree = attrs[:structure].structure_elements.where("level >= #{@parent.level}")
          attrs[:lft] = subtree.maximum(:rgt)
          attrs[:rgt] = attrs[:lft] + 1
        end

        super(attrs)
      end

      after_create do
        parent = @parent
        elements_with_children = {}
        until parent.nil?
          elements_with_children[parent] = parent.reload.child_elements << self
          parent = parent.parent
        end

        elements_with_children.each do |element, children|
          max_right = children.map(&:reload).map(&:rgt).max
          new_right = max_right.present? ? max_right + 1 : parent.lft + 1
          min_left = children.map(&:reload).map(&:lft).min
          new_left = min_left.present? ? min_left - 1 : parent.lft
          element.update(lft: new_left, rgt: new_right)
        end

        update(root: self) if root.nil?
      end
    end
  end
end
