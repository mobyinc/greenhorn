require 'httparty'
require 'fog/aws'
require 'fastimage'
require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class AssetFile < BaseModel
      self.table_name = 'assetfiles'

      belongs_to :element, foreign_key: 'id'
      belongs_to :asset_folder, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'

      before_save { self.dateModified = Time.now.utc }
      after_create do
        connection = Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: asset_source.settings['keyId'],
          aws_secret_access_key: asset_source.settings['secret'],
          region: asset_source.settings['location'],
          path_style: true
        )
        dir = connection.directories.get(asset_source.settings['bucket'])
        expires = asset_source.settings['expires']
        amount = expires.match(/\d+/)[0].to_i
        cache_seconds =
          if expires.include?('second')
            amount
          elsif expires.include?('minute')
            amount.send(:minutes).to_i
          elsif expires.include?('hour')
            amount.send(:hours).to_i
          elsif expires.include?('day')
            amount.send(:days).to_i
          elsif expires.include?('year')
            amount.send(:years).to_i
          end
        cache_headers = expires.present? ? { 'Cache-Control' => "max-age=#{cache_seconds}" } : {}
        file = dir.files.create(
          key: "#{asset_source.settings['subfolder']}/#{filename}",
          body: HTTParty.get(@file),
          public: true,
          metadata: cache_headers
        )
        update(size: file.content_length)
      end

      def initialize(attrs)
        @file = attrs[:file]
        attrs[:element] = Element.create!(type: 'Asset', slug: attrs[:filename], content: Content.new(title: attrs[:filename]))
        attrs[:filename] ||= @file.split('/').last

        if AssetFile.find_by(filename: attrs[:filename], asset_folder: attrs[:asset_folder]).present?
          filename = attrs[:filename]
          name, extension = filename.split('.')
          attrs[:filename] = "#{name}-#{SecureRandom.hex(2)}.#{extension}"
        end

        attrs[:width], attrs[:height] = FastImage.size(@file)
        attrs.delete(:file)
        super(attrs)
      end
    end
  end
end
