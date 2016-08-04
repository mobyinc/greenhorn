module Greenhorn
  class Connection
    def initialize(options)
      @config = OpenStruct.new(
        base_path: options[:base_path]
      )

      Model.descendants.each do |model_class|
        # Not using `Model.table_name_prefix=` b/c AR will
        # ignore the prefix when using the custom name
        next if model_class.abstract_class
        prefix = options[:prefix].present? ? "#{options[:prefix]}_" : ''
        model_class.table_name = "#{prefix}#{model_class.table}"
        model_class.instance_variable_set('@config', @config)
      end

      Greenhorn::Craft::BaseModel.descendants.each do |model_class|
        method_name = model_class.to_s.split('::').last.underscore.pluralize
        define_singleton_method(method_name) { model_class }
      end

      @connection = ActiveRecord::Base.establish_connection(
        options.merge(adapter: 'mysql2')
      )

      Greenhorn::Craft::MatrixContent.define_models
    end

    def transaction(&process)
      ActiveRecord::Base.transaction(&process)
    end

    attr_reader :config

    def extend_config(attrs)
      attrs.each do |key, value|
        @config[key] = value
      end
    end

    def commerce
      Commerce.new
    end

    def neo
      Neo.new
    end

    class Neo
      def initialize
        Greenhorn::Neo::BaseModel.descendants.each do |model_class|
          method_name = model_class.to_s.split('::').last.underscore.pluralize
          define_singleton_method(method_name) { model_class }
        end
      end
    end

    class Commerce
      def initialize
        Greenhorn::Commerce::BaseModel.descendants.each do |model_class|
          method_name = model_class.to_s.split('::').last.underscore.pluralize
          define_singleton_method(method_name) { model_class }
        end
      end
    end
  end
end
