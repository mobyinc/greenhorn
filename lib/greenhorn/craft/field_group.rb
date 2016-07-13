require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class FieldGroup < BaseModel
      has_many :fields, foreign_key: 'groupId'

      def self.table
        'fieldgroups'
      end
    end
  end
end
