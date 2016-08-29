require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Entry < BaseModel
      def self.field_layout_association
        :entry_type
      end
      include ContentBehaviors

      def self.table
        'entries'
      end

      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :type, foreign_key: 'typeId', class_name: 'EntryType'
      has_one :structure_element, through: :element
      has_one :entry_type, through: :section

      validates :section, presence: true

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
        attrs[:element] = Element.create!(
          slug: slug,
          type: 'Entry',
          structure_element: StructureElement.create!(parent: parent_element)
        )
        attrs[:authorId] = 1
        attrs[:type] = section.entry_type
        attrs[:postDate] = Time.current

        super(attrs)
      end

      def assign_attributes(attrs)
        self.section = attrs[:section]
        super(attrs)
      end
    end
  end
end
