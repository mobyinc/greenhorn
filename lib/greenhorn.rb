require 'greenhorn/version'
require 'active_record'
require 'byebug'
require 'uri'

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
      def initialize(string, type = :hyphen)
        @slug = string.downcase.strip
        @slug = if type == :hyphen
                  @slug.gsub(' ', '-').gsub(/[^\w-]/, '')
                else
                  @slug.gsub(' ', '_').gsub(/[^\w-]/, '')
                end
        @slug = @slug.gsub(/[^\w-]/, '')
      end

      def to_s
        @slug
      end
    end

    class Handle
      def initialize(string)
        @handle = string.gsub(' ', '').camelize(:lower)
      end

      def to_s
        @handle
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

      class << self
        def table
          table_name
        end

        def from_boolean(bool)
          bool ? 1 : 0
        end
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

        def add_field_column(handle, type = :text)
          last_field_column = column_names.reverse.find { |col| col[0..5] == 'field_' }
          column_name = "field_#{handle}"
          ActiveRecord::Migration.class_eval do
            add_column :craft_content, column_name, type, after: last_field_column
          end
          reset_column_information
        end

        def remove_field_column(handle)
          column_name = "field_#{handle}"
          table_name = self.table_name
          ActiveRecord::Migration.class_eval do
            remove_column table_name, column_name
          end
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
      class << self
        def allowed_types
          %w(
            PlainText
            RichText
            Number
          )
        end

        def verify_field_type!(type)
          raise "Unknown field type `#{type}`. Must be one of #{allowed_types.map(&:to_sym)}" unless allowed_types.include?(type)
        end

        def column_type_mapping
          {
            'PlainText' => :text,
            'RichText' => :text,
            'Number' => :integer
          }
        end

        def column_type_for(type)
          column_type_mapping[type]
        end

        def verify_column_type(craft_type)
          allowed_types = column_type_mapping.keys
          raise "Don't know what column type should be for `#{craft_type}`" unless allowed_types.include?(craft_type)
        end
      end

      belongs_to :field_group, foreign_key: 'groupId'

      before_create do
        self.handle = Handle.new(name) unless handle.present?
        self.field_group = FieldGroup.first unless field_group.present?
      end

      after_create do
        self.class.verify_column_type(type)
        Content.add_field_column(handle, self.class.column_type_for(type))
      end

      after_destroy do
        Content.remove_field_column(handle)
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

      def attach_field(field_or_handle)
        field = field_or_handle.is_a?(Field) ? field_or_handle : Field.find_by(handle: field_or_handle)
        raise "Couldn't find field with handle `#{field_or_handle}`" unless field.present?
        attached_fields.create!(field: field, tab: default_tab)
      end
    end

    class AssetFolder < Model
      def self.table
        'assetfolders'
      end

      has_many :asset_files, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'
      delegate :path, to: :asset_source
    end

    class AssetFile < Model
      self.table_name = 'assetfiles'
      belongs_to :asset_folder, foreign_key: 'folderId'

      before_save do
        self.dateModified = Time.now.utc
      end
    end

    class AssetSource < Model
      class << self
        def table
          'assetsources'
        end
      end

      SETTINGS_ATTRS = %i(keyId secret bucket subfolder publicUrls urlPrefix expires location)

      belongs_to :field_layout, foreign_key: 'fieldLayoutId'
      has_one :asset_folder, foreign_key: 'sourceId'

      validate :config_is_valid
      validate :url_prefix_is_valid
      serialize :settings, JSON

      before_create do
        self.handle = Slug.new(name, :underscore) unless handle.present?
        self.asset_folder = AssetFolder.new(name: name, path: '')
      end
      after_create do
        update(field_layout: FieldLayout.new(type: 'Asset'))
      end

      def initialize(attrs)
        attrs[:settings] = attrs.slice(*SETTINGS_ATTRS)
        SETTINGS_ATTRS.each { |key| attrs.delete(key) }
        super(attrs)
      end

      def config
        JSON.parse(settings)
      end

      def path
        return nil if config['path'].nil?
        config['path'].sub('{basePath}', 'public/')
      end

      private

      def required_settings
        case type
        when 'S3'
          %w(keyId secret bucket location)
        end
      end

      def config_is_valid
        missing_attrs = required_settings.reject { |key| settings.include?(key) }
        errors.add(:base, "Missing attributes required for #{type} source: #{missing_attrs}") if missing_attrs.present?
      end

      def url_prefix_is_valid
        errors.add(:base, "`urlPrefix` required if `publicUrls = true`") if settings['publicUrls'] && !settings['urlPrefix']
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

    def asset_sources
      AssetSource
    end

    class CraftCollection
      delegate :create,
        :where,
        :destroy_all,
        to: :model

      def model
        raise NotImplementedError
      end

      def transaction(&block)
        ActiveRecord::Base.transaction(&block)
      end

      def now
        Time.current
      end

      def from_boolean(bool)
        bool ? 1 : 0
      end
    end

    class FieldCollection < CraftCollection
      def model
        Field
      end

      def cleaned_attrs(attrs)
        type = attrs[:type] || 'PlainText'
        Field.verify_field_type!(type)

        settings_hash = case type
                          when :rich_text
                            {
                              configFig: attrs[:config_file] || '',
                              availableAssetSources: attrs[:available_asset_sources] || '*',
                              availableTransforms: attrs[:available_transforms] || '*',
                              cleanupHtml: attrs[:cleanup_html] || '1',
                              purifyHtml: attrs[:purify_html] || '1',
                              columnType: 'text'
                            }
                        end
        {
          name: attrs[:name],
          type: type,
          settings: settings_hash
        }
      end

      def create(attrs)
        transaction do
          field = Field.create!(cleaned_attrs(attrs))
        end
      end

      def find_or_create_by(attrs)
        transaction { Field.find_or_create_by!(cleaned_attrs(attrs)) }
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
        belongs_to :default_variant, class_name: 'Variant', foreign_key: 'defaultVariantId'
        has_one :element_locale, through: :element
        has_many :variants, foreign_key: 'productId', dependent: :destroy
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

        def add_field(field)
          field_layout.attach_field(field)
        end

        def verify_fields_attached!(field_handles)
          field_handles = field_handles.map(&:to_s)
          attached_field_handles = field_layout.attached_fields.map(&:field).map(&:handle)
          field_handles.each do |field_handle|
            raise "Field `#{field_handle}` not attached to this product type" unless attached_field_handles.include?(field_handle)
          end
        end
      end

      class TaxCategory < Model
        class << self
          def table
            'commerce_taxcategories'
          end

          def default
            find_by(default: 1)
          end
        end
      end

      class Variant < Model
        def self.table
          'commerce_variants'
        end

        belongs_to :product, foreign_key: 'productId'

        def self.create_from_attrs(attrs)
          non_field_attrs = %i(title product).concat(column_names.map(&:to_sym))
          field_attrs = attrs
            .reject { |key, value| non_field_attrs.include?(key) }
            .map { |key, value| ["field_#{key}", value] }.to_h
          content_attrs = field_attrs.merge(title: attrs[:title])

          element = Element.create!(
            type: 'Commerce_Variant',
            content: Content.new(content_attrs)
          )

          slug = attrs[:slug].present? ? attrs[:slug] : Slug.new(attrs[:title])
          ElementLocale.create!(
            element: element,
            slug: slug,
            locale: 'en_us'
          )

          Variant.create!(
            id: element.id,
            isDefault: from_boolean(attrs[:default]),
            price: attrs[:price],
            sku: attrs[:sku],
            stock: attrs[:stock],
            unlimitedStock: attrs[:unlimitedStock],
            product: attrs[:product]
          )
        end
      end

      class ProductTypeCollection < CraftCollection
        def model
          ProductType
        end

        def cleaned_attrs(attrs)
          {
            name: attrs[:name],
            hasVariants: from_boolean(attrs[:has_variants] || false),
          }
        end

        def find_or_create_by(attrs)
          transaction { ProductType.find_or_create_by!(cleaned_attrs(attrs)) }
        end

        def create(attrs)
          transaction do
            product_type = ProductType.create!(cleaned_attrs(attrs))

            if attrs[:fields].present?
              attrs[:fields].each do |field|
                product_type.add_field(field)
              end
            end

            product_type
          end
        end
      end

      class ProductCollection < CraftCollection
        def model
          Product
        end

        def create(attrs)
          raise "Can't create a product without a type" if attrs[:type].nil?

          transaction do
            non_field_attrs = %i(title type defaultSku defaultPrice)
            field_attrs = attrs.reject { |key, value| non_field_attrs.include?(key) }
            attrs[:type].verify_fields_attached!(field_attrs.keys)
            field_attrs = field_attrs.map { |key, value| ["field_#{key}", value] }.to_h
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

            product = Product.create!(
              id: element.id,
              type: attrs[:type],
              defaultSku: attrs[:defaultSku],
              defaultPrice: attrs[:defaultPrice],
              tax_category: TaxCategory.default,
            )

            default_variant_params = attrs[:default_variant_params] || {}
            default_variant_params[:isDefault] = true
            default_variant_params[:title] ||= attrs[:title]
            default_variant_params[:sku] ||= attrs[:defaultSku]
            default_variant_params[:price] ||= attrs[:defaultPrice]
            default_variant_params[:stock] ||= 0
            unlimited_stock = default_variant_params[:unlimitedStock] || true
            default_variant_params[:unlimitedStock] = from_boolean(unlimited_stock)
            default_variant_params[:product] = product

            product.default_variant = Variant.create_from_attrs(default_variant_params)
            product
          end
        end
      end

      class VariantCollection < CraftCollection
        def model
          Variant
        end

        def create(attrs)
          transaction { Variant.create_from_attrs(attrs) }
        end
      end

      def products
        @products ||= ProductCollection.new
      end

      def product_types
        @product_types ||= ProductTypeCollection.new
      end

      def variants
        @variants ||= VariantCollection.new
      end
    end
  end
end
