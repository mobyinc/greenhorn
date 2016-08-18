require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxZoneCountry < BaseModel
      class << self
        def table
          'commerce_taxzone_countries'
        end
      end

      belongs_to :tax_zone, foreign_key: 'taxZoneId'
      belongs_to :country, foreign_key: 'countryId'
    end
  end
end
