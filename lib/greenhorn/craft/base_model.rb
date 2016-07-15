require 'greenhorn/core/model'

module Greenhorn
  module Craft
    class BaseModel < Model
      self.inheritance_column = :_type_disabled
      self.abstract_class = true

      def root_element
        raise NotImplementedError unless respond_to?(:structure)
        structure.structure_elements.find_by(level: 0)
      end
    end
  end
end
