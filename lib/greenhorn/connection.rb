module Greenhorn
  class Connection
    def initialize(options)
      Model.descendants.each do |model_class|
        # Not using `Model.table_name_prefix=` b/c AR will
        # ignore the prefix when using the custom name
        next if model_class.abstract_class
        prefix = options[:prefix].present? ? "#{options[:prefix]}_" : ''
        model_class.table_name = "#{prefix}#{model_class.table}"
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

    def commerce
      Commerce.new
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
