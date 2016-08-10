require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Element < BaseModel
      has_one :content, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_one :entry, foreign_key: 'id'
      has_many :element_locales, foreign_key: 'elementId'
      has_many :neo_blocks, foreign_key: 'ownerId', class_name: 'Neo::Block'

      delegate :slug, to: :element_locale, allow_nil: true
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

      def add_neo_block(attrs)
        neo_blocks.create!(attrs)
      end
    end
  end
end
