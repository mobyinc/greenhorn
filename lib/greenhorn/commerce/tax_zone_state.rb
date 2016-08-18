require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxZoneState < BaseModel
      class << self
        def table
          'commerce_taxzone_states'
        end
      end

      belongs_to :tax_zone, foreign_key: 'taxZoneId'
      belongs_to :state, foreign_key: 'stateId'
    end
  end
end
