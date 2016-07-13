require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxCategory < BaseModel
      class << self
        def table
          'commerce_taxcategories'
        end

        def default
          find_by(default: 1)
        end
      end
    end
  end
end
