require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Section < BaseModel
      def self.table
        'sections'
      end

      has_many :entries, foreign_key: 'sectionId'
      has_one :section_locale, foreign_key: 'id'
      has_one :entry_type, foreign_key: 'sectionId'
      has_many :section_locales, foreign_key: 'sectionId', class_name: 'SectionLocale'
      belongs_to :structure, foreign_key: 'structureId'

      before_create do
        self.handle = Utility::Slug.new(name) unless handle.present?
        self.structure = Structure.create!
      end

      after_create do
        EntryType.create!(section: self, handle: handle, name: name, fields: @fields)
        root_element = StructureElement.create!(structure: structure, lft: 1, rgt: 2, level: 0)
        root_element.update!(root: root_element)
        section_locales << SectionLocale.create!(locale: 'en_us', section: self)
      end

      def initialize(attrs)
        @fields = attrs.delete(:fields)
        super(attrs)
      end

      def add_field(field)
        entry_type.field_layout.attach_field(field)
      end

      def single?
        type == 'single'
      end

      def channel?
        type == 'channel'
      end

      def structure?
        type == 'structure'
      end
    end
  end
end
