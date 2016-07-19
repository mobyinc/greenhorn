require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Content < BaseModel
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

      after_create do
        @matrix_fields.each do |matrix_handle, block_groups|
          block_groups.each do |block_group|
            block_group.each do |block_handle, fields|
              attrs = { element: element, matrix_handle: matrix_handle, block_handle: block_handle }
              fields.each do |field_handle, value|
                attrs["field_#{block_handle}_#{field_handle}"] = value
              end
              MatrixContent.create(attrs)
            end
          end
        end

        @asset_fields.each do |handle, value|
          field = Greenhorn::Craft::Field.find_by(handle: handle)
          asset_source = Greenhorn::Craft::AssetSource.find(field.settings['defaultUploadLocationSource'].to_i)

          value = [value] unless value.is_a?(Array)
          value.each do |file_attributes|
            file_attributes = { 'url' => file_attributes } unless file_attributes.is_a?(Hash)
            asset_file = Greenhorn::Craft::AssetFile.create!(
              file: file_attributes['url'],
              title: file_attributes['title'],
              asset_source: asset_source,
              asset_folder: asset_source.asset_folder
            )
            Greenhorn::Craft::Relation.create!(field: field, source: element, target: asset_file.element)
          end
        end
      end

      def initialize(attrs)
        @matrix_fields = {}

        field_attrs = attrs.reject { |key, _value| %i(title).include?(key.to_sym) }
        asset_fields, regular_fields = field_attrs.partition do |field_handle, _value|
          field = Greenhorn::Craft::Field.find_by(handle: field_handle)
          field.type == 'Assets'
        end.map(&:to_h)
        @asset_fields = asset_fields

        field_attrs.each { |key, _value| attrs.delete(key) }
        field_attrs = regular_fields.map { |key, value| ["field_#{key}", value] }.to_h
        field_attrs.each do |field_handle, value|
          next if %i(title).include?(field_handle)
          handle = field_handle.split('field_').last

          field = Field.find_by(handle: handle)
          if field.matrix?
            @matrix_fields[handle] = value
            field_attrs.delete(field_handle)
          end
        end

        super(field_attrs.merge(locale: 'en_us', title: attrs[:title]))
      end
    end
  end
end
