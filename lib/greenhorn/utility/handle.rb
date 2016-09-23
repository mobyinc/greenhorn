module Greenhorn
  module Utility
    class Handle
      def initialize(string)
        unless string.present?
          raise Greenhorn::Errors::MissingAttributeError, "Can't create handle without a string"
        end

        @handle = string.downcase.split(' ').map(&:camelize).join.gsub(/[^a-zA-Z]/, '').camelize(:lower)
      end

      def to_s
        @handle
      end
    end
  end
end
