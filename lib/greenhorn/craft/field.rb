require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Field < BaseModel
      class << self
        def table
          'fields'
        end

        def field_info
          {
            PlainText: {
              column_attrs: [:text],
              default_settings: { placeholder: '', maxLength: '', multiline: '', initialRows: '4' }
            },
            Color: {
              column_attrs: [:text],
              default_settings: { }
            },
            RichText: {
              column_attrs: [:text],
              default_settings:
                {
                  configFile: '',
                  availableAssetSources: '*',
                  availableTransforms: '*',
                  cleanupHtml: '1',
                  purifyHtml: '1',
                  columnType: 'text'
                }
            },
            Dropdown: {
              column_attrs: [:text],
              default_settings:
                {
                  options: []
                }
            },
            Checkboxes: {
              column_attrs: [:text],
              default_settings:
                {
                  options: []
                }
            },
            MobyFieldPack_Position: {
              column_attrs: [:text],
              default_settings:
                {
                  options: ['left', 'right', 'center']
                }
            },
            MobyFieldPack_Padding: {
              column_attrs: [:text],
              default_settings: {}
            },
            MobyFieldPack_MinMax: {
              column_attrs: [:text],
              default_settings: {}
            },
            MobyFieldPack_Range: {
              column_attrs: [:text],
              default_settings: {
                minValue: 0,
                maxValue: 1,
                stepsValue: 0
              }
            },
            PositionSelect: {
              column_attrs: [:text],
              default_settings:
                {
                  options: ['left','right','center']
                }
            },
            Number: { column_attrs: [:float], default_settings: { min: '0', max: '', decimals: '0' } },
            Lightswitch: { column_attrs: [:boolean], default_settings: { default: '' } },
            Assets: {
              column_attrs: [:text],
              default_settings:
                {
                  useSingleFolder: '1',
                  sources: '*',
                  defaultUploadLocationSource: '',
                  defaultUploadLocationSubpath: '',
                  singleUploadLocationSource: '',
                  singleUploadLocationSubpath: '',
                  restrictFiles: '0',
                  allowedKinds: [],
                  limit: '',
                  viewMode: 'list',
                  selectionLabel: ''
                }
            },
            LinkIt: {
              column_attrs: [:text],
              default_settings:
                {
                  types: ['custom', 'entry', 'product'],
                  defaultText: '',
                  allowCustomText: '1',
                  allowTarget: '1',
                  entrySources: '*',
                  entrySelectionLabel: 'Select an entry',
                  assetSources: '*',
                  assetSelectionLabel: 'Select an asset',
                  categorySources: '*',
                  categorySelectionLabel: 'Select a category',
                  productSources: '*',
                  productSelectionLabel: 'Select a product'
                }
            },
            Wistia: {
              column_attrs: [:text],
              default_settings:
                {
                  useSingleProject: '0'
                }
            },
            Matrix: { default_settings: { maxBlocks: nil } },
            Neo: { default_settings: { maxBlocks: nil } },
            Entries: { default_settings: { sources: [], limit: '', selectionLabel: '' } },
            Categories: { default_settings: { source: nil, limit: '', selectionLabel: '', targetLocale: '' } },
            Commerce_Products: { default_settings: { sources: '*', limit: '', selectionLabel: '', targetLocale: '' } },
            Tags: { default_settings: { source: nil, limit: '', selectionLabel: '', targetLocale: '' } },
          }.with_indifferent_access
        end

        def allowed_types
          field_info.keys
        end

        def verify_field_type!(type)
          unless allowed_types.include?(type)
            raise "Unknown field type `#{type}`. Must be one of #{allowed_types.map(&:to_sym)}"
          end
        end

        def column_attrs_for(type)
          column_attrs = field_info[type]['column_attrs']
          column_attrs
        end
      end

      def default_settings_for(type)
        self.class.field_info[type][:default_settings]
      end

      serialize :settings, JSON
      belongs_to :field_group, foreign_key: 'groupId'
      has_many :block_types, foreign_key: 'fieldId', class_name: 'MatrixBlockType'
      has_many :neo_block_types, foreign_key: 'fieldId', class_name: 'Neo::BlockType'
      has_many :neo_groups, foreign_key: 'fieldId', class_name: 'Neo::Group'
      has_many :relations, foreign_key: 'fieldId'

      validate :handle_is_unique
      validate :sources_are_valid

      before_create do
        self.handle = Utility::Handle.new(name) unless handle.present?
        self.field_group = FieldGroup.first unless field_group.present? || part_of_matrix?
      end

      after_create do
        column_attrs = self.class.column_attrs_for(type)
        if type == 'Matrix'
          MatrixContent.add_table(handle)
          (@attrs[:block_types] || []).each do |block_type|
            block_types.create!(block_type)
          end
        elsif type == 'Neo'
          (@attrs[:block_types] || []).each do |block_type|
            neo_block_types.create!(block_type)
          end

          (@attrs[:groups] || []).each do |group|
            neo_groups.create!(group)
          end
        elsif part_of_matrix? && column_attrs.present?
          MatrixContent.add_field_column(matrix_handle, matrix_field_handle, *column_attrs)
        elsif column_attrs.present?
          Content.add_field_column(handle, *column_attrs)
        end
      end

      def add_block_type(block_type)
        if type == 'Matrix'
          block_types.find_or_create_by!(block_type)
        elsif type == 'Neo'
          existing_block_type = neo_block_types.find_by(name: block_type[:name])
          existing_block_type || neo_block_types.create!(block_type)
        else
          raise "Can't add block type to a #{type} field"
        end
      end

      after_destroy do
        if type == 'Matrix'
          MatrixContent.remove_table(handle)
        elsif !part_of_matrix?
          column_type = self.class.column_type_for(type)
          Content.remove_field_column(handle) if column_type.present?
        end
      end

      def initialize(attrs)
        attrs = attrs.with_indifferent_access
        @attrs = attrs
        type = attrs[:type] || 'PlainText'
        self.class.verify_field_type!(type)

        default_settings = default_settings_for(type)
        attrs[:restrictFiles] = 1 if attrs[:allowedKinds].present?
        settings = default_settings.merge(attrs.slice(*default_settings.keys))

        if attrs[:sources].present?
          settings[:sources] = attrs[:sources].map do |source_section|
            "section:#{source_section.id}"
          end
        end

        if attrs[:source].present?
          if type == 'Tags'
            settings[:source] = "taggroup:#{attrs[:source].id}"
          else
            settings[:source] = "group:#{attrs[:source].id}"
          end
        end

        if attrs[:options].present?
          attrs[:options].each_with_index do |option, i|
            begin
              if option.is_a?(Hash)
                option[:default] = option[:default] === true ? '1' : '0'
              else
                attrs[:options][i] = {label: option, value: option, default: false}
              end
            rescue Exception => e
            end
          end
        end

        default_upload_location_source = settings[:defaultUploadLocationSource]
        if default_upload_location_source.present? && !default_upload_location_source.is_a?(String)
          settings[:defaultUploadLocationSource] = default_upload_location_source.id.to_s
        end
        single_upload_location_source = settings[:singleUploadLocationSource]
        if single_upload_location_source.present? && !single_upload_location_source.is_a?(String)
          settings[:singleUploadLocationSource] = single_upload_location_source.id.to_s
        end

        attrs = {
          name: attrs[:name],
          handle: attrs[:handle],
          field_group: attrs[:field_group],
          type: type,
          context: attrs[:context] || 'global',
          settings: default_settings.merge(settings)
        }
        super(attrs)
      end

      def handle_is_unique
        errors.add(:handle, 'is already taken') if Field.find_by(handle: handle, context: 'global').present?
      end

      def part_of_matrix?
        context.include?('matrix')
      end

      def matrix_block_type
        return nil unless part_of_matrix?
        MatrixBlockType.find(context.split('matrixBlockType:').last.to_i)
      end

      def matrix_field
        return nil if matrix_block_type.nil?
        matrix_block_type.field
      end

      def matrix_handle
        return nil if matrix_field.nil?
        matrix_field.handle
      end

      def matrix_field_handle
        return nil if matrix_block_type.nil?
        "#{matrix_block_type.handle}_#{handle}"
      end

      def matrix?
        type == 'Matrix'
      end

      def ensure_valid_source!(item)
        if type == 'Entries'
          sources = settings['sources'].map do |source_identifier|
            Section.find(source_identifier[8..-1])
          end
          return if sources.nil? || sources.include?(item.section)

          raise Greenhorn::Errors::InvalidOperationError,
            "Can't attach entry type #{item.section.name}, allowed entry types: #{sources.map(&:name).join(',')}"
        elsif type == 'Categories'
          source = CategoryGroup.find(settings['source'][6..-1])
          return if source == item.category_group

          raise Greenhorn::Errors::InvalidOperationError,
            "Can't attach category group #{item.category_group.name}, allowed group: #{source.name}"
        elsif type == 'Tags'
          source = TagGroup.find(settings['source'][9..-1])
          return if source == item.tag_group

          raise Greenhorn::Errors::InvalidOperationError,
            "Can't attach tag group #{item.tag_group.name}, allowed group: #{source.name}"
        elsif type == 'Assets'
          # TODO
        end
      end

      private

      def sources_are_valid
        errors.add(:base, "Source must be specified") if type == 'Categories' && settings['source'].nil?
      end
    end
  end
end
