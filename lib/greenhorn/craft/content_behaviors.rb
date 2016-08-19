module Greenhorn
  module Craft
    module ContentBehaviors
      def self.included(base)
        base.class_eval do
          belongs_to :element, foreign_key: 'id', class_name: 'Craft::Element'
          has_one :element_locale, through: :element
          has_one :content, through: :element, class_name: 'Craft::Content'
          has_one :field_layout, through: field_layout_association, class_name: 'Craft::FieldLayout'

          after_create { self.element.content = Content.new(@content_attrs) }
          after_update { self.element.content.update(@content_attrs) }
        end
      end

      def non_field_attributes
        column_names = self.class.column_names
        (column_names + methods + methods.map { |method| method.to_s.sub('=', '') }).map(&:to_sym)
      end

      def field_attributes(attrs)
        attrs.reject { |key, _value| non_field_attributes.include?(key) }
      end

      def assign_attributes(attrs)
        field_attrs = field_attributes(attrs)
        field_layout_association = self.class.field_layout_association
        if field_attrs.present?
          (attrs[field_layout_association] || send(field_layout_association)).verify_fields_attached!(field_attrs.keys)
        end

        field_attrs.each { |key, _value| attrs.delete(key) }
        @content_attrs = field_attrs.merge(title: attrs[:title])

        attrs.delete(:title)

        super(attrs)
      end
    end
  end
end
