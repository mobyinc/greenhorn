require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Relation < BaseModel
      def self.table
        'relations'
      end

      belongs_to :field, foreign_key: 'fieldId'
      belongs_to :source, class_name: 'Element', foreign_key: 'sourceId'
      belongs_to :target, class_name: 'Element', foreign_key: 'targetId'
    end
  end
end
