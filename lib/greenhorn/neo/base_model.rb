module Greenhorn
  module Neo
    class BaseModel < Model
      self.inheritance_column = :_type_disabled
      self.abstract_class = true

      def next_sort_order
        max_block = field.neo_block_types.maximum(:sortOrder) || 0
        max_group = field.neo_groups.maximum(:sortOrder) || 0

        [max_group, max_block].max + 1
      end
    end
  end
end
