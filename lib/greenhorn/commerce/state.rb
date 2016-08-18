require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class State < BaseModel
      class << self
        def table
          'commerce_states'
        end

        def find_by_name_or_abbr(name_or_abbr)
          find_by(name: name_or_abbr) || find_by(abbreviation: name_or_abbr)
        end
      end
    end
  end
end
