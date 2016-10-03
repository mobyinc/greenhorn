require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Element < BaseModel
      def self.table
        'elements'
      end

      has_many :contents, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_many :element_locales, foreign_key: 'elementId'
      has_many :matrix_blocks, foreign_key: 'ownerId', class_name: 'MatrixBlock'
      has_many :neo_blocks, foreign_key: 'ownerId', class_name: 'Neo::Block'

      delegate :slug, to: :element_locale, allow_nil: true
      delegate :title, to: :content

      after_create do
        Locale.all.each do |locale|
          element_locales << ElementLocale.create!(
            element: self,
            slug: @attrs[:slug],
            locale: locale.locale
          )
          content_attrs = @content_attrs || {}
          next if contents.find_by(locale: locale.locale).present?
          contents << Content.create!(content_attrs.merge(
            element: self,
            locale: locale.locale
          ))
        end
      end

      def initialize(attrs)
        @attrs = attrs.dup
        @content = attrs.delete(:content)
        @content_attrs = attrs.delete(:content_attrs)
        if @content.present?
          # TODO temporary hack to cirumvent new multiple-content for multi locales
          attrs[:contents] = [@content]
        end
        attrs.delete(:slug)
        super(attrs)
      end

      def add_neo_block(attrs)
        neo_blocks.create!(attrs)
      end

      def item
        case type
        when 'Asset' then AssetFile.find(id)
        when 'Entry' then Entry.find(id)
        when 'Category' then Category.find(id)
        when 'Commerce_Product' then Commerce::Product.find(id)
        when 'Tag' then Tag.find(id)
        end
      end

      def content
        contents.find_by(locale: 'en_us')
      end
    end
  end
end
