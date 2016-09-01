require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class MatrixContent < BaseModel
      self.abstract_class = true

      belongs_to :element, foreign_key: 'elementId'

      class << self
        def define_models
          return
          Field.where(type: 'Matrix').each do |matrix_field|
            model_class = model_class_for(matrix_field.handle)
          end
        end

        def model_class_for(handle)
          klass = "MatrixContent_#{handle}"
          return klass.constantize if const_defined?(klass)

          model_class = Class.new(self)
          model_class.table_name = content_table_name(handle)
          Object.const_set klass, model_class
        end

        def content_table_name(matrix_handle)
          "craft_matrixcontent_#{matrix_handle}"
        end

        def add_table(handle)
          table_name = content_table_name(handle)
          if ActiveRecord::Base.connection.table_exists?(table_name)
            puts "Matrix table #{table_name} already exists, not re-creating..."
            return
          end

          ActiveRecord::Migration.class_eval do
            create_table(table_name) do |t|
              t.integer :elementId
              t.column :locale, 'char(12)'
              t.string :title
              t.datetime :dateCreated
              t.datetime :dateUpdated
              t.column :uid, 'char(36)'
            end
          end
        end

        def remove_table(handle)
          table_name = content_table_name(handle)
          ActiveRecord::Migration.class_eval do
            drop_table(table_name)
          end
        end

        def add_field_column(matrix_handle, field_handle, column_type)
          table_name = content_table_name(matrix_handle)
          column_name = "field_#{field_handle}"

          if self.model_class_for(matrix_handle).column_names.include?(column_name)
            puts "Matrix column #{column_name} already exists, not re-creating..."
            return
          end

          ActiveRecord::Migration.class_eval do
            add_column(table_name, column_name, column_type, after: :locale)
          end
        end

        def create(options)
          block = MatrixBlock.create!(
            owner: options[:element],
            type: MatrixBlockType.find_by(handle: options[:block_handle]),
            field: Field.find_by(handle: options[:matrix_handle])
          )
          model_class = model_class_for(options[:matrix_handle])
          options[:element] = block.element
          options.delete(:matrix_handle)
          options.delete(:block_handle)
          options[:locale] = 'en_us'
          model_class.create!(options)
        end
      end

      def field_values
        handle = block.type.handle
        values = { type: handle }
        attributes
          .select { |attribute, value| attribute.starts_with?("field_#{handle}") }
          .each { |attribute, value| values[attribute.sub("field_#{handle}_", '').to_sym] = value }
        values
      end

      def handle
        self.class.name[14..-1]
      end

      def field
        Field.find_by(handle: handle)
      end

      def block
        MatrixBlock.find(element.id)
      end

      def block_types
        field.block_types
      end
    end
  end
end
