require 'greenhorn/commerce/base_model'

module Greenhorn
  module Craft
    class Tag < BaseModel
      def self.field_layout_association
        :tag_group
      end
      include Craft::ContentBehaviors

      # @!visibility private
      class << self
        def table
          'tags'
        end
      end

      before_create do
        self.element = Element.create!(
          type: 'Tag',
          content: Content.new(title: @attrs[:title])
        )
      end

      def assign_attributes(attrs)
        @attrs = attrs
        super(attrs)
      end

      belongs_to :tag_group, foreign_key: 'groupId', class_name: 'TagGroup'
    end
  end
end
