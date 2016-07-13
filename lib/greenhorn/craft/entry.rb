require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Entry < BaseModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :element, foreign_key: 'id'
      has_many :element_locale, through: :element

      validates :section, presence: true

      def initialize(attrs)
        section = attrs[:section]

        non_field_attrs = %i(section title)
        field_attrs = attrs
                      .reject { |key, _value| non_field_attrs.include?(key) }
                      .map { |key, value| ["field_#{key}", value] }
                      .to_h
        @content_attrs = field_attrs.merge(title: attrs[:title])

        structure = section.structure
        max_right = StructureElement.where(structure: structure, level: 1).maximum(:rgt)
        left = max_right.present? ? max_right + 1 : 0
        right = left + 1

        element = Element.create!(
          type: 'Entry',
          content: Content.new(@content_attrs),
          structure_element: StructureElement.create(
            root: 1,
            lft: left,
            rgt: right,
            level: 1,
            structureId: structure.id
          )
        )

        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        ElementLocale.create!(element: element, slug: slug, locale: 'en_us')

        super(
          section: section,
          element: element,
          id: element.id,
          authorId: 1,
          typeId: section.entry_type.id,
          postDate: Time.current
        )
      end
    end
  end
end
