require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Structure < BaseModel
      has_many :structure_elements, foreign_key: 'structureId'
    end
  end
end
