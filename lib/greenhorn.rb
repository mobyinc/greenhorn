require 'greenhorn/version'
require 'active_record'
require 'byebug'

module Greenhorn
  class Craft
    def initialize(options)
      Model.descendants.each do |model_class|
        # Not using `Model.table_name_prefix=` b/c AR will 
        # ignore the prefix when using the custom name
        prefix = options[:prefix].present? ? "#{options[:prefix]}_" : ''
        model_class.table_name = "#{prefix}#{model_class.table}"
      end

      @connection = ActiveRecord::Base.establish_connection(
        options[:connection].merge(adapter: 'mysql2')
      )
    end

    def commerce
      Commerce.new
    end

    class Slug
      def initialize(string)
        @slug = string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end

      def to_s
        @slug
      end
    end

    class UID
      def initialize
        @uid = [sub(8), sub(4), sub(4), sub(4), sub(12)].join('-')
      end

      def sub(length)
        SecureRandom.hex(length / 2)
      end

      def to_s
        @uid
      end
    end

    class Model < ActiveRecord::Base
      self.inheritance_column = :_type_disabled
      self.abstract_class = true
      def self.table
        table_name
      end

      def craft_table_name
        table_name
      end

      before_create do
        self.uid = UID.new
        self.dateCreated = Time.now.utc

        if respond_to?(:postDate)
          self.postDate = Time.now.utc
        end
      end

      before_save do
        self.dateUpdated = Time.now.utc
      end
    end

    class CategoryGroup < Model
      self.table_name = 'categorygroups'
      has_many :categories, foreign_key: 'groupId'
    end

    class Category < Model
      belongs_to :category_group, foreign_key: 'groupId'
      belongs_to :element, foreign_key: 'id'
    end

    class Element < Model
      delegate :slug, to: :element_locale, allow_nil: true
      has_one :content, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_one :entry, foreign_key: 'id'
      has_one :element_locale, foreign_key: 'elementId'
    end

    class Entry < Model
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :element, foreign_key: 'id'
      has_one :element_locale, through: :element
    end

    class EntryType < Model
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId'

      def self.table
        'entrytypes'
      end

      before_create do
        self.field_layout = FieldLayout.create!(type: 'Entry')
      end
    end

    class Section < Model
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
      end

      def add_field(field)
        entry_type.field_layout.attach_field(field)
      end
    end

    class SectionLocale < Model
      self.table_name = 'sections_i18n'
      belongs_to :section, foreign_key: 'sectionId'
    end

    class Content < Model
      class << self
        def table
          'content'
        end

        def add_field_column(handle)
          last_field_column = column_names.reverse.find { |col| col[0..5] == 'field_' }
          column_name = "field_#{handle.downcase}"
          ActiveRecord::Migration.class_eval do
            add_column :craft_content, column_name, :text, after: last_field_column
          end
          reset_column_information
        end
      end

      belongs_to :element, foreign_key: 'elementId'

      before_create do
        self.locale = 'en_us'
      end
    end

    class ElementLocale < Model
      self.table_name = 'elements_i18n'
      belongs_to :element, foreign_key: 'elementId'
      before_save do
        section_locale = element.entry.try(:section).try(:section_locale)
        if section_locale.present? && section_locale.urlFormat.present?
          self.uri = section_locale.urlFormat.sub '{slug}', slug
        end
      end
    end

    class Structure < Model; end

    class StructureElement < Model
      def self.table
        'structureelements'
      end

      belongs_to :element, foreign_key: 'elementId'
      belongs_to :structure, foreign_key: 'structureId'
    end

    class Relation < Model; end

    class Field < Model
      belongs_to :field_group, foreign_key: 'groupId'

      before_create do
        self.handle = Slug.new(name) unless handle.present?
        self.field_group = FieldGroup.first unless field_group.present?
      end

      after_create do
        Content.add_field_column(handle)
      end
    end

    class Schema
      def self.modify(&block)
        ActiveRecord::Migration.class_eval(&block)
      end
    end

    class FieldGroup < Model
      has_many :fields, foreign_key: 'groupId'

      def self.table
        'fieldgroups'
      end
    end

    class FieldLayoutField < Model
      belongs_to :field_layout, foreign_key: 'layoutId'
      belongs_to :tab, class_name: 'FieldLayoutTab', foreign_key: 'tabId'
      belongs_to :field, foreign_key: 'fieldId'

      def self.table
        'fieldlayoutfields'
      end
    end

    class FieldLayoutTab < Model
      belongs_to :field_layout, foreign_key: 'layoutId'

      def self.table
        'fieldlayouttabs'
      end
    end

    class FieldLayout < Model
      has_one :entry_type, foreign_key: 'fieldLayoutId'
      has_many :attached_fields, class_name: 'FieldLayoutField', foreign_key: 'layoutId'
      has_many :tabs, class_name: 'FieldLayoutTab', foreign_key: 'layoutId'

      def self.table
        'fieldlayouts'
      end

      def default_tab
        tabs.first || tabs.create!(name: 'Tab 1')
      end

      def attach_field(field)
        attached_fields.create!(field: field, tab: default_tab)
      end
    end

    class AssetFolder < Model
      self.table_name = 'assetfolders'
      has_many :asset_files, foreign_key: 'folderId'
      delegate :path, to: :asset_source

      def asset_source
        AssetSource.find_by(name: name)
      end
    end

    class AssetFile < Model
      self.table_name = 'assetfiles'
      belongs_to :asset_folder, foreign_key: 'folderId'

      before_save do
        self.dateModified = Time.now.utc
      end
    end

    class AssetSource < Model
      self.table_name = 'assetsources'

      def config
        JSON.parse(settings)
      end

      def path
        return nil if config['path'].nil?
        config['path'].sub('{basePath}', 'public/')
      end
    end

    def fields
      @fields ||= FieldCollection.new
    end

    def entries
      @entries ||= EntryCollection.new
    end

    def sections
      @sections || SectionCollection.new
    end

    class CraftCollection
      def transaction(&block)
        ActiveRecord::Base.transaction(&block)
      end

      def now
        Time.current
      end

      def destroy_all
        model.destroy_all
      end
    end

    class FieldCollection < CraftCollection
      def find_or_create_by(attrs)
        transaction do
          Field.find_or_create_by(attrs)
        end
      end
    end

    class SectionCollection < CraftCollection
      def find_or_create_by(attrs)
        transaction do
          section = Section.find_or_create_by(attrs)

          if attrs[:fields].present?
            attrs[:fields].each { |field| section.add_field(field) }
          end

          section
        end
      end
    end

    class EntryCollection < CraftCollection
      def create(attrs)
        raise "Can't create an entry without a section" unless attrs[:section].present?

        transaction do
          section = attrs[:section]
          structure = section.structure
          content = attrs[:content]

          max_right = StructureElement.where(structure: structure, level: 1).maximum(:rgt)
          left = max_right.present? ? max_right + 1 : 0
          right = left + 1

          non_field_attrs = %i(section title)
          field_attrs = attrs
            .reject { |key, value| non_field_attrs.include?(key) }
            .map { |key, value| ["field_#{key}", value] }
            .to_h
          content_attrs = field_attrs.merge(title: attrs[:title])

          element = Element.create!(
            type: 'Entry',
            content: Content.new(content_attrs),
            structure_element: StructureElement.create(
              root: 1,
              lft: left,
              rgt: right,
              level: 1,
              structureId: structure.id
            )
          )

          slug = attrs[:slug].present? ? attrs[:slug] : Slug.new(attrs[:title])
          ElementLocale.create!(
            element: element,
            slug: slug,
            locale: 'en_us'
          )

          section.entries.create!(
            id: element.id,
            authorId: 1,
            typeId: section.entry_type.id,
            postDate: now,
          )
        end
      end
    end

    class Commerce
      class Product < Model
        def self.table
          'commerce_products'
        end

        belongs_to :element, foreign_key: 'id'
        belongs_to :type, class_name: 'ProductType', foreign_key: 'typeId'
        belongs_to :tax_category, foreign_key: 'taxCategoryId'
        has_one :element_locale, through: :element
      end

      class ProductType < Model
        def self.table
          'commerce_producttypes'
        end

        belongs_to :field_layout, foreign_key: 'fieldLayoutId'
        belongs_to :variant_field_layout, class_name: 'FieldLayout', foreign_key: 'variantFieldLayoutId'

        before_create do
          self.handle = Slug.new(name) unless handle.present?
          self.titleFormat = '{product.title}' unless titleFormat.present?
          self.field_layout = FieldLayout.create!(type: 'Commerce_Product')
          self.variant_field_layout = FieldLayout.create!(type: 'Commerce_Variant')
        end
      end

      class TaxCategory < Model
        def self.table
          'commerce_taxcategories'
        end
      end

      class ProductTypeCollection < CraftCollection
        def find_or_create_by(attrs)
          transaction { ProductType.find_or_create_by!(attrs) }
        end

        def create(attrs)
          transaction { ProductType.create!(attrs) }
        end
      end

      class ProductCollection < CraftCollection
        def model
          Product
        end

        def create(attrs)
          raise "Can't create a product without a type" if attrs[:type].nil?

          transaction do
            non_field_attrs = %i(title type defaultPrice)
            field_attrs = attrs
              .reject { |key, value| non_field_attrs.include?(key) }
              .map { |key, value| ["field_#{key}", value] }
              .to_h
            content_attrs = field_attrs.merge(title: attrs[:title])

            element = Element.create!(
              type: 'Commerce_Product',
              content: Content.new(content_attrs)
            )

            slug = attrs[:slug].present? ? attrs[:slug] : Slug.new(attrs[:title])
            ElementLocale.create!(
              element: element,
              slug: slug,
              locale: 'en_us'
            )

            Product.create!(
              id: element.id,
              type: attrs[:type],
              defaultPrice: attrs[:defaultPrice],
              tax_category: TaxCategory.first
            )
          end
        end
      end

      def products
        @products ||= ProductCollection.new
      end

      def product_types
        @product_types ||= ProductTypeCollection.new
      end
    end
  end
end
