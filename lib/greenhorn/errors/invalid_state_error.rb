module Greenhorn
  module Errors
    class InvalidStateError < StandardError
      def initialize(state)
        super("#{state} does not match any known state name or abbreviation")
      end
    end
  end
end
