require 'greenhorn/craft/base_model'
require 'greenhorn/craft/field_behaviors'

module Greenhorn
  module Craft
    class AssetSource < BaseModel
      include Craft::FieldBehaviors

      class << self
        def table
          'assetsources'
        end

        def default_settings_for(type)
          case type
          when 'S3'
            { subfolder: '', publicUrls: '0', urlPrefix: '', expires: '' }
          when 'Local'
            { publicUrls: '0' }
          end
        end
      end

      SETTINGS_ATTRS = %i(keyId secret bucket subfolder publicUrls urlPrefix expires location path url).freeze

      belongs_to :field_layout, foreign_key: 'fieldLayoutId'
      has_one :asset_folder, foreign_key: 'sourceId' # TODO: this should be has_many
      has_many :asset_files, foreign_key: 'sourceId'

      validates :type, inclusion: { in: %w(S3 Local Webdam) }
      validate :config_is_valid
      validate :url_prefix_is_valid

      serialize :settings, JSON

      before_create do
        self.handle = Utility::Slug.new(name, :underscore) unless handle.present?
        build_asset_folder(name: name, path: '')
        create_field_layout(type: 'Asset')
      end

      def initialize(attrs)
        require_attributes!(attrs, %i(name type))
        super(attrs)
      end

      def assign_attributes(attrs)
        default_settings = self.class.default_settings_for(attrs[:type])
        attrs[:settings] = default_settings.merge(attrs.slice(*SETTINGS_ATTRS))
        SETTINGS_ATTRS.each { |key| attrs.delete(key) }
        super(attrs)
      end

      def config
        JSON.parse(settings)
      end

      def path
        return nil if config['path'].nil?
        config['path'].sub('{basePath}', 'public/')
      end

      private

      def required_settings
        case type
        when 'Local'
          %w(path)
        when 'S3'
          %w(keyId secret bucket location)
        end
      end

      def config_is_valid
        return true if type == 'Webdam' #hack for now- these don't actually get saved for real
        missing_attrs = required_settings.reject { |key| settings.include?(key) }
        errors.add(:base, "Missing attributes required for #{type} source: #{missing_attrs}") if missing_attrs.present?
      end

      def url_prefix_is_valid
        if settings['publicUrls'] && !(settings['urlPrefix'] || settings['url'])
          errors.add(:base, '`urlPrefix` required if `publicUrls = true`')
        end
      end
    end
  end
end
