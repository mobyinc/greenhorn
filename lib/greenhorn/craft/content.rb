require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Content < BaseModel
      class << self
        def table
          'content'
        end

        def add_field_column(handle, *attrs)
          reset_column_information

          last_field_column = column_names.reverse.find { |col| col[0..5] == 'field_' }

          if attrs.last.is_a?(Hash)
            attrs.last[:after] = last_field_column
          else
            attrs << { after: last_field_column }
          end

          column_name = "field_#{handle}"

          ActiveRecord::Migration.class_eval do
            add_column :craft_content, column_name, *attrs
          end
          reset_column_information
        end

        def remove_field_column(handle)
          reset_column_information

          column_name = "field_#{handle}"
          table_name = self.table_name
          ActiveRecord::Migration.class_eval do
            remove_column table_name, column_name
          end
        end
      end

      belongs_to :element, foreign_key: 'elementId'

      after_save do
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

          upload_subpath = field.settings['singleUploadLocationSubpath']
          folder = upload_subpath.present? ? AssetFolder.find_by(path: upload_subpath) : asset_source.asset_folder

          clear_field_relations(field)

          value = [value] unless value.is_a?(Array)
          value.each do |file_attributes|
            next if file_attributes.nil?
            asset_file =
              if file_attributes.is_a?(Craft::AssetFile)
                file_attributes
              else
                file_attributes = { 'url' => file_attributes } unless file_attributes.is_a?(Hash)
                Greenhorn::Craft::AssetFile.create!(
                  file: file_attributes['url'],
                  title: file_attributes['title'],
                  asset_source: asset_source,
                  asset_folder: folder
                )
              end
            Greenhorn::Craft::Relation.create!(field: field, source: element, target: asset_file.element)
          end
        end

        @category_fields.merge(@entry_fields).each do |handle, values|
          field = Greenhorn::Craft::Field.find_by(handle: handle)
          clear_field_relations(field)

          values = [values] unless values.is_a?(Array)
          values.each do |value|
            field.ensure_valid_source!(value)
            Greenhorn::Craft::Relation.create!(field: field, source: element, target: value.element)
          end
        end
      end

      def assign_attributes(attrs)
        @matrix_fields = {}

        field_attrs = attrs.reject { |key, _value| %i(title).include?(key.to_sym) }

        grouped_attrs = field_attrs.group_by do |field_handle, _value|
          Greenhorn::Craft::Field.find_by(handle: field_handle).type
        end
        @asset_fields = (grouped_attrs['Assets'] || []).to_h
        @category_fields = (grouped_attrs['Categories'] || []).to_h
        @entry_fields = (grouped_attrs['Entries'] || []).to_h
        regular_fields = field_attrs.reject do |field_handle, _value|
          @asset_fields.keys.include?(field_handle) ||
            @category_fields.keys.include?(field_handle) ||
            @entry_fields.keys.include?(field_handle)
        end

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

        field_attrs[:title] = attrs[:title] if attrs[:title].present?

        super(field_attrs.merge(locale: 'en_us'))
      end

      def field(handle)
        field_value = self["field_#{handle}"]
        return field_value unless field_value.nil?

        field = Field.find_by(handle: handle)
        case field.type
        when 'Assets', 'Entries'
          field.relations.where(source: element).map(&:target).map(&:item)
        end
      end

      private

      def clear_field_relations(field)
        current_relations = Craft::Relation.where(field: field, source: element)
        current_relations.destroy_all
      end
    end
  end
end
