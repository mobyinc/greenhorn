module Greenhorn
  module Utility
    class UID
      def initialize
        @uid = [sub(8), sub(4), sub(4), sub(4), sub(12)].join('-')
      end

      def sub(length)
        SecureRandom.hex(length / 2)
      end

      def to_s
        @uid
      end
    end
  end
end
