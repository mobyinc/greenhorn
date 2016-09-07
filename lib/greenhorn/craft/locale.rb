require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Locale < BaseModel
      def self.table
        'locales'
      end
    end
  end
end
