require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Structure < BaseModel
      has_many :structure_elements, foreign_key: 'structureId'

      def root_element
        structure_elements.find_by(level: 0)
      end

      def print_tree
        p '---'
        reload.structure_elements.each do |structure_element|
          title = structure_element.element.try(:title) || '[Root]'
          puts "#{title} - #{structure_element.level} - (#{structure_element.lft}, #{structure_element.rgt})"
        end
      end
    end
  end
end
