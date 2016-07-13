require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class CategoryGroup < BaseModel
      self.table_name = 'categorygroups'
      has_many :categories, foreign_key: 'groupId'
    end
  end
end
