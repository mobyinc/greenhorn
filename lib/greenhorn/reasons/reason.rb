require 'greenhorn/craft/base_model'

module Greenhorn
  module Reasons
    class Reason < BaseModel
      class << self
        def table
          'reasons'
        end

        def create_or_update(attrs)
          existing = find_by(field_layout: attrs[:field_layout])
          if existing.present?
            existing.update(attrs)
          else
            create(attrs)
          end
        end
      end

      belongs_to :field_layout, foreign_key: 'fieldLayoutId', class_name: 'Craft::FieldLayout'

      serialize :conditionals, JSON
    end
  end
end
