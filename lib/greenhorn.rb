require 'greenhorn/version'
require 'httparty'
require 'active_record'
require 'byebug'
require 'uri'
require 'fog/aws'
require 'fastimage'

module Greenhorn
  class Craft
    def initialize(options)
      Model.descendants.each do |model_class|
        # Not using `Model.table_name_prefix=` b/c AR will 
        # ignore the prefix when using the custom name
        next if model_class.abstract_class
        prefix = options[:prefix].present? ? "#{options[:prefix]}_" : ''
        model_class.table_name = "#{prefix}#{model_class.table}"
      end

      CoreModel.descendants.each do |model_class|
        method_name = model_class.to_s.split('::').last.underscore.pluralize
        define_singleton_method(method_name) { model_class }
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

      def from_boolean(bool)
        bool ? 1 : 0
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

    class CoreModel < Model
      self.inheritance_column = :_type_disabled
      self.abstract_class = true
    end

    class CategoryGroup < CoreModel
      self.table_name = 'categorygroups'
      has_many :categories, foreign_key: 'groupId'
    end

    class Category < CoreModel
      belongs_to :category_group, foreign_key: 'groupId'
      belongs_to :element, foreign_key: 'id'
    end

    class Element < CoreModel
      delegate :slug, to: :element_locale, allow_nil: true
      has_one :content, foreign_key: 'elementId'
      has_one :structure_element, foreign_key: 'elementId'
      has_one :entry, foreign_key: 'id'
      has_many :element_locales, foreign_key: 'elementId'
    end

    class Entry < CoreModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :element, foreign_key: 'id'
      has_many :element_locale, through: :element

      validates :section, presence: true

      before_create do
      end

      def initialize(attrs)
        section = attrs[:section]
        content = attrs[:content]

        non_field_attrs = %i(section title)
        field_attrs = attrs
          .reject { |key, value| non_field_attrs.include?(key) }
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

        slug = attrs[:slug].present? ? attrs[:slug] : Slug.new(attrs[:title])
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

    class EntryType < CoreModel
      belongs_to :section, foreign_key: 'sectionId'
      belongs_to :field_layout, foreign_key: 'fieldLayoutId'

      def self.table
        'entrytypes'
      end

      before_create do
        self.field_layout = FieldLayout.create!(type: 'Entry')
      end
    end

    class Section < CoreModel
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

    class SectionLocale < CoreModel
      self.table_name = 'sections_i18n'
      belongs_to :section, foreign_key: 'sectionId'
    end

    class Content < CoreModel
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

    class ElementLocale < CoreModel
      self.table_name = 'elements_i18n'
      belongs_to :element, foreign_key: 'elementId'
      before_save do
        section_locale = element.entry.try(:section).try(:section_locale)
        if section_locale.present? && section_locale.urlFormat.present?
          self.uri = section_locale.urlFormat.sub '{slug}', slug
        end
      end
    end

    class Structure < CoreModel; end

    class StructureElement < CoreModel
      def self.table
        'structureelements'
      end

      belongs_to :element, foreign_key: 'elementId'
      belongs_to :structure, foreign_key: 'structureId'
    end

    class Relation < CoreModel
      belongs_to :field, foreign_key: 'fieldId'
      belongs_to :source, class_name: 'Element', foreign_key: 'sourceId'
      belongs_to :target, class_name: 'Element', foreign_key: 'targetId'
    end

    class Field < CoreModel
      class << self
        def allowed_types
          %w(
            PlainText
            RichText
            Number
            Assets
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
      end

      def default_settings_for(type)
        case type
        when 'PlainText'
          { placeholder: '', maxLength: '', multiline: '', initialRows: '4' }
        when 'RichText'
          { configFig: '', availableAssetSources: '*', availableTransforms: '*', cleanupHtml: '1', purifyHtml: '1', columnType: 'text' }
        when 'Number'
          { min: '0', max: '', decimals: '0' }
        when 'Assets'
          {
            useSingleFolder: '1', sources: '*', defaultUploadLocationSource: '', defaultUploadLocationSubpath: '',
            singleUploadLocationSource: '',
            singleUploadLocationSubpath: '',
            restrictFiles: '0',
            allowedKinds: [],
            limit: '',
            viewMode: 'list',
            selectionLabel: ''
          }
        end
      end

      serialize :settings, JSON
      belongs_to :field_group, foreign_key: 'groupId'

      before_create do
        self.handle = Handle.new(name) unless handle.present?
        self.field_group = FieldGroup.first unless field_group.present?
      end

      after_create do
        column_type = self.class.column_type_for(type)
        if column_type.present?
          Content.add_field_column(handle, column_type)
        end
      end

      after_destroy do
        column_type = self.class.column_type_for(type)
        if column_type.present?
          Content.remove_field_column(handle)
        end
      end

      def initialize(attrs)
        type = attrs[:type] || 'PlainText'
        default_settings = default_settings_for(type)
        settings = default_settings.merge(attrs.slice(*default_settings.keys))

        default_upload_location_source = settings[:defaultUploadLocationSource]
        if default_upload_location_source.present? && !default_upload_location_source.is_a?(String)
          settings[:defaultUploadLocationSource] = default_upload_location_source.id.to_s
        end
        single_upload_location_source = settings[:singleUploadLocationSource]
        if single_upload_location_source.present? && !single_upload_location_source.is_a?(String)
          settings[:singleUploadLocationSource] = single_upload_location_source.id.to_s
        end

        self.class.verify_field_type!(type)
        attrs = {
          name: attrs[:name],
          type: type,
          settings: default_settings.merge(settings)
        }
        super(attrs)
      end
    end

    class Schema
      def self.modify(&block)
        ActiveRecord::Migration.class_eval(&block)
      end
    end

    class FieldGroup < CoreModel
      has_many :fields, foreign_key: 'groupId'

      def self.table
        'fieldgroups'
      end
    end

    class FieldLayoutField < CoreModel
      belongs_to :field_layout, foreign_key: 'layoutId'
      belongs_to :tab, class_name: 'FieldLayoutTab', foreign_key: 'tabId'
      belongs_to :field, foreign_key: 'fieldId'

      def self.table
        'fieldlayoutfields'
      end
    end

    class FieldLayoutTab < CoreModel
      belongs_to :field_layout, foreign_key: 'layoutId'

      def self.table
        'fieldlayouttabs'
      end
    end

    class FieldLayout < CoreModel
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

    class AssetFolder < CoreModel
      def self.table
        'assetfolders'
      end

      has_many :asset_files, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'
      delegate :path, to: :asset_source
    end

    class AssetFile < CoreModel
      self.table_name = 'assetfiles'

      belongs_to :element, foreign_key: 'id'
      belongs_to :asset_folder, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'

      before_save { self.dateModified = Time.now.utc }
      after_create do
        connection = Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: asset_source.settings['keyId'],
          aws_secret_access_key: asset_source.settings['secret'],
          region: asset_source.settings['location'],
          path_style: true
        )
        dir = connection.directories.get(asset_source.settings['bucket'])
        expires = asset_source.settings['expires']
        amount = expires.match(/\d+/)[0].to_i
        cache_seconds =
          if expires.include?('second')
            amount
          elsif expires.include?('minute')
            amount.send(:minutes).to_i
          elsif expires.include?('hour')
            amount.send(:hours).to_i
          elsif expires.include?('day')
            amount.send(:days).to_i
          elsif expires.include?('year')
            amount.send(:years).to_i
          end
        cache_headers = expires.present? ? { 'Cache-Control' => "max-age=#{cache_seconds}" } : {}
        file = dir.files.create(
          key: "#{asset_source.settings['subfolder']}/#{filename}",
          body: HTTParty.get(@file),
          public: true,
          metadata: cache_headers
        )
        update(size: file.content_length)
      end

      def initialize(attrs)
        asset_source = attrs[:asset_source]
        @file = attrs[:file]
        attrs[:element] = Element.create!(type: 'Asset')
        attrs[:filename] ||= @file.split('/').last

        if AssetFile.find_by(filename: attrs[:filename], asset_folder: attrs[:asset_folder]).present?
          filename = attrs[:filename]
          name, extension = filename.split('.')
          attrs[:filename] = "#{name}-#{SecureRandom.hex(2)}.#{extension}"
        end

        attrs[:element].element_locales.create!(slug: attrs[:filename], locale: 'en_us')
        attrs[:width], attrs[:height] = FastImage.size(@file)
        Content.create!(element: attrs[:element], title: attrs[:filename])
        attrs.delete(:file)
        super(attrs)
      end
    end

    class AssetSource < CoreModel
      class << self
        def table
          'assetsources'
        end

        def default_settings_for(type)
          case type
          when 'S3'
            {
              subfolder: '',
              publicUrls: '0',
              urlPrefix: '',
              expires: ''
            }
          end
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
        default_settings = self.class.default_settings_for(attrs[:type])
        attrs[:settings] = default_settings.merge(attrs.slice(*SETTINGS_ATTRS))
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

    class Commerce
      def initialize
        CommerceModel.descendants.each do |model_class|
          method_name = model_class.to_s.split('::').last.underscore.pluralize
          define_singleton_method(method_name) { model_class }
        end
      end

      class CommerceModel < Model
        self.inheritance_column = :_type_disabled
        self.abstract_class = true
      end

      class Product < CommerceModel
        def self.table
          'commerce_products'
        end

        belongs_to :element, foreign_key: 'id'
        belongs_to :type, class_name: 'ProductType', foreign_key: 'typeId'
        belongs_to :tax_category, foreign_key: 'taxCategoryId'
        belongs_to :default_variant, class_name: 'Variant', foreign_key: 'defaultVariantId'
        has_one :element_locale, through: :element
        has_many :variants, foreign_key: 'productId', dependent: :destroy
        accepts_nested_attributes_for :default_variant

        validates :type, presence: true

        def initialize(attrs)
          non_field_attrs = %i(title type tax_category).concat(self.class.column_names.map(&:to_sym))
          field_attrs = attrs.reject { |key, value| non_field_attrs.include?(key) }
          attrs[:type].verify_fields_attached!(field_attrs.keys)

          asset_fields, regular_fields = field_attrs.partition do |field_handle, value|
            field = Field.find_by(handle: field_handle)
            field.type == 'Assets'
          end.map(&:to_h)

          field_attrs.each { |key, value| attrs.delete(key) }
          field_attrs = regular_fields.map { |key, value| ["field_#{key}", value] }.to_h
          content_attrs = field_attrs.merge(title: attrs[:title])

          element = Element.create!(
            type: 'Commerce_Product',
            content: Content.new(content_attrs)
          )

          asset_fields.each do |handle, value|
            field = Field.find_by(handle: handle)
            asset_source = AssetSource.find(field.settings['defaultUploadLocationSource'].to_i)

            value = [value] unless value.is_a?(Array)
            value.each do |file|
              asset_file = AssetFile.create!(file: file, kind: 'image', asset_source: asset_source, asset_folder: asset_source.asset_folder)
              Relation.create!(field: field, source: element, target: asset_file.element)
            end
          end

          slug = attrs[:slug].present? ? attrs[:slug] : Slug.new(attrs[:title])
          ElementLocale.create!(
            element: element,
            slug: slug,
            locale: 'en_us'
          )

          default_variant_params = attrs[:default_variant_params] || {}
          default_variant_params[:isDefault] = true
          default_variant_params[:title] ||= attrs[:title]
          default_variant_params[:sku] ||= attrs[:defaultSku]
          default_variant_params[:price] ||= attrs[:defaultPrice]
          default_variant_params[:stock] ||= 0
          unlimited_stock = default_variant_params[:unlimitedStock] || true
          default_variant_params[:unlimitedStock] = from_boolean(unlimited_stock)
          default_variant_params[:product] = self

          attrs[:default_variant_attributes] = default_variant_params
          attrs[:tax_category] ||= TaxCategory.default
          attrs[:id] = element.id
          attrs.delete(:title)

          super(attrs)
        end
      end

      class ProductType < CommerceModel
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

        after_create do
          if @fields.present?
            @fields.each do |field|
              add_field(field)
            end
          end
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

        def initialize(attrs)
          attrs[:hasVariants] = from_boolean(attrs[:hasVariants] || false)
          @fields = attrs[:fields]
          attrs.delete(:fields)
          super(attrs)
        end
      end

      class TaxCategory < CommerceModel
        class << self
          def table
            'commerce_taxcategories'
          end

          def default
            find_by(default: 1)
          end
        end
      end

      class Variant < CommerceModel
        def self.table
          'commerce_variants'
        end

        belongs_to :product, foreign_key: 'productId'

        def initialize(attrs)
          non_field_attrs = %w(title product).concat(self.class.column_names)
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

          super(
            id: element.id,
            isDefault: from_boolean(attrs[:isDefault]),
            price: attrs[:price],
            sku: attrs[:sku],
            stock: attrs[:stock],
            unlimitedStock: attrs[:unlimitedStock],
            product: attrs[:product]
          )
        end
      end
    end
  end
end
