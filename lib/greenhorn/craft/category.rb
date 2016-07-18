require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Category < BaseModel
      belongs_to :category_group, foreign_key: 'groupId'
      belongs_to :element, foreign_key: 'id'
      validates :category_group, presence: true
      has_one :structure_element, through: :element

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
    end
  end
end
