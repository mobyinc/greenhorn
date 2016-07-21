require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Field < BaseModel
      class << self
        def allowed_types
          %w(
            PlainText
            RichText
            Number
            Assets
            Matrix
            Neo
          )
        end

        def verify_field_type!(type)
          unless allowed_types.include?(type)
            raise "Unknown field type `#{type}`. Must be one of #{allowed_types.map(&:to_sym)}"
          end
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
          {
            configFig: '',
            availableAssetSources: '*',
            availableTransforms: '*',
            cleanupHtml: '1',
            purifyHtml: '1',
            columnType: 'text'
          }
        when 'Number'
          { min: '0', max: '', decimals: '0' }
        when 'Assets'
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
        when 'Matrix', 'Neo'
          { maxBlocks: nil }
        end
      end

      serialize :settings, JSON
      belongs_to :field_group, foreign_key: 'groupId'
      has_many :block_types, foreign_key: 'fieldId', class_name: 'MatrixBlockType'
      has_many :neo_block_types, foreign_key: 'fieldId', class_name: 'Neo::BlockType'

      validate :handle_is_unique

      before_create do
        self.handle = Utility::Handle.new(name) unless handle.present?
        self.field_group = FieldGroup.first unless field_group.present? || part_of_matrix?
      end

      after_create do
        if type == 'Matrix'
          MatrixContent.add_table(handle)
          (@attrs[:block_types] || []).each do |block_type|
            block_types.create!(block_type)
          end
        elsif type == 'Neo'
          (@attrs[:block_types] || []).each do |block_type|
            neo_block_types.create!(block_type)
          end
        elsif part_of_matrix?
          column_type = self.class.column_type_for(type)
          MatrixContent.add_field_column(matrix_handle, matrix_field_handle, column_type)
        else
          column_type = self.class.column_type_for(type)
          Content.add_field_column(handle, column_type) if column_type.present?
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
        @attrs = attrs
        type = attrs[:type] || 'PlainText'
        default_settings = default_settings_for(type)
        attrs[:restrictFiles] = 1 if attrs[:allowedKinds].present?
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
          handle: attrs[:handle],
          type: type,
          context: attrs[:context] || 'global',
          settings: default_settings.merge(settings)
        }
        super(attrs)
      end

      def handle_is_unique
        errors.add(:handle, "is already taken") if Field.find_by(handle: handle, context: 'global').present?
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
    end
  end
end
