module Greenhorn
  module Utility
    class Handle
      def initialize(string)
        @handle = string.gsub(' ', '').camelize(:lower)
      end

      def to_s
        @handle
      end
    end
  end
end
