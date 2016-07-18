require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class MatrixContent < BaseModel
      self.abstract_class = true

      belongs_to :element, foreign_key: 'elementId'

      class << self
        def add_table(handle)
          table_name = "craft_matrixcontent_#{handle}"
          ActiveRecord::Migration.class_eval do
            create_table(table_name) do |t|
              t.integer :elementId
              t.column :locale, "char(12)"
              t.datetime :dateCreated
              t.datetime :dateUpdated
              t.column :uid, "char(36)"
            end
          end
        end

        def remove_table(handle)
          table_name = "craft_matrixcontent_#{handle}"
          ActiveRecord::Migration.class_eval do
            drop_table(table_name)
          end
        end

        def add_field_column(matrix_handle, field_handle, column_type)
          table_name = "craft_matrixcontent_#{matrix_handle}"
          column_name = "field_#{field_handle}"
          ActiveRecord::Migration.class_eval do
            add_column(table_name, column_name, column_type, after: :locale)
          end
        end
      end
    end
  end
end
