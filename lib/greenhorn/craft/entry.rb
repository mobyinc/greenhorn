require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Entry < BaseModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :element, foreign_key: 'id'
      belongs_to :type, foreign_key: 'typeId', class_name: 'EntryType'
      has_many :element_locales, through: :element
      has_one :structure_element, through: :element
      has_one :entry_type, through: :section
      has_one :field_layout, through: :entry_type
      has_one :content, through: :element
      accepts_nested_attributes_for :content

      validates :section, presence: true

      delegate :title, to: :content

      class << self
        def find_by_title(title)
          matching_elements = Content.where(title: title).map(&:element)
          Entry.find_by(element: matching_elements)
        end
      end

      def initialize(attrs)
        require_attributes!(attrs)

        if attrs[:parent].present?
          section = attrs[:parent].section
          parent_element = attrs[:parent].structure_element
        elsif attrs[:section].present?
          section = attrs[:section]
          parent_element = section.root_element
        else
          raise Errors::MissingAttributeError, 'Must specify either `section` or `parent` when creating entry'
        end

        slug = attrs[:slug].present? ? attrs[:slug] : Greenhorn::Utility::Slug.new(attrs[:title])
        element = Element.create!(
          slug: slug,
          type: 'Entry',
          content: Content.new(content_attrs_for(attrs)),
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

      def assign_attributes(attrs)
        content_attrs = content_attrs_for(attrs)
        content_attrs.keys.each { |key| attrs.delete(key) }
        content.update(content_attrs)
        super(attrs)
      end

      def slug
        element_locales.first.slug
      end

      private

      def content_attrs_for(attrs)
        non_field_attrs = %i(section title parent)
        field_attrs = attrs
                      .reject { |key, _value| non_field_attrs.include?(key) }
                      .to_h
        field_attrs[:title] = attrs[:title] if attrs[:title].present?
        field_attrs
      end
    end
  end
end
