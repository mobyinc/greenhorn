require 'active_record'
require 'greenhorn/utility/uid'

module Greenhorn
  class Model < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.abstract_class = true

    class << self
      def table
        table_name
      end

      def from_boolean(bool)
        bool ? 1 : 0
      end
    end

    before_create do
      self.uid = Utility::UID.new
      self.dateCreated = Time.now.utc

      self.postDate = Time.now.utc if respond_to?(:postDate)
    end

    before_save do
      self.dateUpdated = Time.now.utc
    end

    def from_boolean(bool)
      bool ? 1 : 0
    end

    def craft_table_name
      table_name
    end

    def require_attributes!(attrs, required_keys = [])
      class_name = self.class.name.demodulize
      if attrs.nil?
        raise Errors::MissingAttributeError, "Can't create #{class_name} without #{required_keys.join(', ')}"
      end

      required_keys.each do |key|
        raise Errors::MissingAttributeError, "Can't create #{class_name} without `#{key}`" if attrs[key].nil?
      end
    end

    def config
      self.class.instance_variable_get('@config')
    end

    def content_attributes_for(attrs)
      field_attrs = attrs.reject { |key, _value| non_field_attrs.include?(key) }
      field_attrs.merge(title: attrs[:title])
    end

    def non_content_attributes_for(attrs)
      content_keys = content_attributes_for(attrs).keys
      attrs.reject { |key, _value| content_keys.include?(key) }
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
  end
end
