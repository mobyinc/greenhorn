require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Section < BaseModel
      has_many :entries, foreign_key: 'sectionId'
      has_one :section_locale, foreign_key: 'id'
      has_one :entry_type, foreign_key: 'sectionId'
      belongs_to :structure, foreign_key: 'structureId'

      before_create do
        self.handle = Slug.new(name) unless handle.present?
        self.structure = Structure.create!
      end

      after_create do
        EntryType.create!(section: self, handle: handle, name: name)
        if @fields.present?
          @fields.each { |field| section.add_field(field) }
        end
      end

      def initialize(attrs)
        @fields = attrs[:fields]
        super(attrs.delete(:fields))
      end

      def add_field(field)
        entry_type.field_layout.attach_field(field)
      end
    end
  end
end
