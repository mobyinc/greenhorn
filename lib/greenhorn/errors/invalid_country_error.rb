module Greenhorn
  module Errors
    class InvalidCountryError < StandardError
      def initialize(country)
        super("#{country} does not match any known country name or ISO code")
      end
    end
  end
end
