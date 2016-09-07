module Greenhorn
  module Craft
    module ContentBehaviors
      def self.included(base)
        base.class_eval do
          base.extend(ClassMethods)

          belongs_to :element, foreign_key: 'id', class_name: 'Craft::Element'
          has_one :structure_element, through: :element
          has_many :element_locales, through: :element
          has_many :contents, through: :element, class_name: 'Craft::Content'
          if respond_to?(:field_layout_association)
            has_one :field_layout, through: field_layout_association, class_name: 'Craft::FieldLayout'
          else
            def field_layout
              send(self.class.field_layout_parent).field_layout
            end
          end

          delegate :content, to: :element
          delegate :title, to: :content

          after_create do
            Locale.all.map do |locale|
              content = Content.find_or_create_by!(element: element, locale: locale.locale)
              @content_attrs[:title] = title if @content_attrs[:title].nil?
              content.update(@content_attrs.merge(element: element, locale: locale.locale))
            end
          end
          after_update { element.content.update(@content_attrs.merge(element: element)) }
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
        if self.class.respond_to?(:field_layout_association)
          self.class.field_layout_association
        else
          self.class.field_layout_parent
        end
      end

      # @!visibility private
      def method_missing(method, *options)
        if respond_to?(:field_layout) && field_layout.present? && respond_to?(:content)
          method_matches_field = field_layout.field?(method)
          method_matches_field ? content.field(method) : super
        else
          super
        end
      end

      def fields_match?(fields)
        fields.all? do |field, value|
          self.send(field) == value
        end
      end

      module ClassMethods
        def find_by(options)
          if options[:section].present?
            field_matches = options.slice(*options[:section].field_handles.map(&:to_sym))
            field_matches.keys.each { |field_handle| options.delete(field_handle) }

            results = where(options)
            results.to_a.find do |result|
              result.fields_match?(field_matches)
            end
          else
            super(options)
          end
        end
      end
    end
  end
end
