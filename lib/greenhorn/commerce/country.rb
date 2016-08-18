require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Country < BaseModel
      class << self
        def table
          'commerce_countries'
        end

        def find_by_name_or_iso(name_or_iso)
          find_by(name: name_or_iso) || find_by(iso: name_or_iso)
        end
      end
    end
  end
end
