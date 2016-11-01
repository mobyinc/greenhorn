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

        def find_by_slug(slug)
        end
      end

      before_create do
        self.element = Element.create!(
          type: 'Tag',
          slug: @slug,
          content: Content.new(title: @attrs[:title])
        )
      end

      def assign_attributes(attrs)
        @slug = attrs.delete(:slug) || Greenhorn::Utility::Slug.new(attrs[:title])
        @attrs = attrs
        super(attrs)
      end

      belongs_to :tag_group, foreign_key: 'groupId', class_name: 'TagGroup'
    end
  end
end
