require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Category < BaseModel
      include Craft::ContentBehaviors

      belongs_to :category_group, foreign_key: 'groupId'

      validates :category_group, presence: true

      class << self
        def table
          'categories'
        end

        def find_by_title(title)
          matching_elements = Content.where(title: title).map(&:element)
          Category.find_by(element: matching_elements)
        end
      end

      def initialize(attrs)
        parent_element =
          if attrs[:parent].present?
            attrs[:parent].structure_element
          else
            attrs[:category_group].root_element
          end

        attrs[:category_group] ||= attrs[:parent].category_group

        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        element = Element.create!(
          slug: slug,
          type: 'Category',
          content: Content.new(title: attrs[:title]),
          structure_element: StructureElement.create!(parent: parent_element)
        )

        attrs.delete(:title)
        attrs.delete(:parent)
        attrs[:id] = element.id
        super(attrs)
      end

      def locales
        element_locales.map(&:source_locale)
      end

      def field_layout
        category_group.field_layout
      end
    end
  end
end
