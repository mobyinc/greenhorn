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
      end

      def initialize(attrs)
        @matrix_fields = {}
        attrs.each do |field_handle, value|
          next if %i(field_description title).include?(field_handle)
          handle = field_handle.split('field_').last

          field = Field.find_by(handle: handle)
          if field.matrix?
            @matrix_fields[handle] = value
            attrs.delete(field_handle)
          end
        end

        super(attrs.merge(locale: 'en_us'))
      end
    end
  end
end
