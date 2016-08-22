module Greenhorn
  module Craft
    module ContentBehaviors
      def self.included(base)
        base.class_eval do
          belongs_to :element, foreign_key: 'id', class_name: 'Craft::Element'
          has_one :element_locale, through: :element
          has_one :content, through: :element, class_name: 'Craft::Content'
          if respond_to?(:field_layout_association)
            has_one :field_layout, through: field_layout_association, class_name: 'Craft::FieldLayout'
          else
            def field_layout
              send(self.class.field_layout_parent).field_layout
            end
          end

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
        if field_attrs.present?
          (attrs[field_layout_method] || send(field_layout_method)).verify_fields_attached!(field_attrs.keys)
        end

        field_attrs.each { |key, _value| attrs.delete(key) }
        @content_attrs = field_attrs.merge(title: attrs[:title])

        attrs.delete(:title)

        super(attrs)
      end

      def field_layout_method
        self.class.respond_to?(:field_layout_association) ? self.class.field_layout_association : self.class.field_layout_parent
      end
    end
  end
end
