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
        self.handle = Utility::Handle.new(name) unless handle.present?
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
  end
end
