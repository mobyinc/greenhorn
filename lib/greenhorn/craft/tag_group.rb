require 'greenhorn/commerce/base_model'

module Greenhorn
  module Craft
    class TagGroup < BaseModel
      include Craft::FieldBehaviors

      # @!visibility private
      class << self
        def table
          'taggroups'
        end
      end

      before_create do
        self.handle = Utility::Slug.new(name) unless handle.present?
        self.field_layout = Greenhorn::Craft::FieldLayout.create!(type: 'Tag')
      end

      has_many :tags, foreign_key: 'groupId'
    end
  end
end
