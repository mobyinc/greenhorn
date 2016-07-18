require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Entry < BaseModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :element, foreign_key: 'id'
      belongs_to :type, foreign_key: 'typeId', class_name: 'EntryType'
      has_many :element_locale, through: :element
      has_one :structure_element, through: :element

      validates :section, presence: true

      def initialize(attrs)
        if attrs[:parent].present?
          section = attrs[:parent].section
          parent_element = attrs[:parent].structure_element
        else
          section = attrs[:section]
          parent_element = section.root_element
        end

        non_field_attrs = %i(section title parent)
        field_attrs = attrs
                      .reject { |key, _value| non_field_attrs.include?(key) }
                      .map { |key, value| ["field_#{key}", value] }
                      .to_h
        @content_attrs = field_attrs.merge(title: attrs[:title])

        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        element = Element.create!(
          slug: slug,
          type: 'Entry',
          content: Content.new(@content_attrs),
          structure_element: StructureElement.create!(parent: parent_element)
        )

        super(
          section: section,
          element: element,
          id: element.id,
          authorId: 1,
          type: section.entry_type,
          postDate: Time.current
        )
      end
    end
  end
end
