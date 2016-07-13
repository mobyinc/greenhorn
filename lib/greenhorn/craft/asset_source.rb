require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class AssetSource < BaseModel
      class << self
        def table
          'assetsources'
        end

        def default_settings_for(type)
          case type
          when 'S3'
            {
              subfolder: '',
              publicUrls: '0',
              urlPrefix: '',
              expires: ''
            }
          end
        end
      end

      SETTINGS_ATTRS = %i(keyId secret bucket subfolder publicUrls urlPrefix expires location).freeze

      belongs_to :field_layout, foreign_key: 'fieldLayoutId'
      has_one :asset_folder, foreign_key: 'sourceId'

      validate :config_is_valid
      validate :url_prefix_is_valid
      serialize :settings, JSON

      before_create do
        self.handle = Utility::Slug.new(name, :underscore) unless handle.present?
        self.asset_folder = AssetFolder.new(name: name, path: '')
      end
      after_create do
        update(field_layout: FieldLayout.new(type: 'Asset'))
      end

      def initialize(attrs)
        default_settings = self.class.default_settings_for(attrs[:type])
        attrs[:settings] = default_settings.merge(attrs.slice(*SETTINGS_ATTRS))
        SETTINGS_ATTRS.each { |key| attrs.delete(key) }
        super(attrs)
      end

      def config
        p settings
        JSON.parse(settings)
      end

      def path
        return nil if config['path'].nil?
        config['path'].sub('{basePath}', 'public/')
      end

      private

      def required_settings
        case type
        when 'S3'
          %w(keyId secret bucket location)
        end
      end

      def config_is_valid
        missing_attrs = required_settings.reject { |key| settings.include?(key) }
        errors.add(:base, "Missing attributes required for #{type} source: #{missing_attrs}") if missing_attrs.present?
      end

      def url_prefix_is_valid
        if settings['publicUrls'] && !settings['urlPrefix']
          errors.add(:base, '`urlPrefix` required if `publicUrls = true`')
        end
      end
    end
  end
end
