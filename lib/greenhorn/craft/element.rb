require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Element < BaseModel
      delegate :slug, to: :element_locale, allow_nil: true
      has_one :content, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_one :entry, foreign_key: 'id'
      has_many :element_locales, foreign_key: 'elementId'

      delegate :title, to: :content

      after_create do
        element_locales << ElementLocale.create!(
          element: self,
          slug: @attrs[:slug],
          locale: 'en_us'
        )
      end

      def initialize(attrs)
        @attrs = attrs.dup
        attrs.delete(:slug)
        super(attrs)
      end
    end
  end
end
