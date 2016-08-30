require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class ElementLocale < BaseModel
      def self.table
        'elements_i18n'
      end

      belongs_to :element, foreign_key: 'elementId'
    end
  end
end
