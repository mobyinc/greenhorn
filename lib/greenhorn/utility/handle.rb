module Greenhorn
  module Utility
    class Handle
      def initialize(string)
        unless string.present?
          raise Greenhorn::Errors::MissingAttributeError, "Can't create slug without a string"
        end

        @handle = string.downcase.split(' ').map(&:camelize).join.camelize(:lower)
      end

      def to_s
        @handle
      end
    end
  end
end
