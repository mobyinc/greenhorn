require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Category < BaseModel
      belongs_to :category_group, foreign_key: 'groupId'
      belongs_to :element, foreign_key: 'id'
    end
  end
end
