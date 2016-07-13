require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Element < BaseModel
      delegate :slug, to: :element_locale, allow_nil: true
      has_one :content, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_one :entry, foreign_key: 'id'
      has_many :element_locales, foreign_key: 'elementId'
    end
  end
end
