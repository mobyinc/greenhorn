require 'httparty'
require 'addressable'
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
        begin
          file = dir.files.create(
            key: "#{asset_source.settings['subfolder']}/#{filename}",
            body: HTTParty.get(@file, uri_adapter: Addressable::URI),
            public: true,
            metadata: cache_headers
          )
          update(size: file.content_length)
        rescue Exception => e
          p "WARNING: Unable to fetch asset #{@file}, error was: #{e}"
        end
      end

      def initialize(attrs)
        @file = attrs[:file]
        attrs[:filename] ||= @file.split('/').last
        title = attrs[:title] || attrs[:filename]
        attrs[:element] = Element.create!(type: 'Asset', slug: attrs[:filename], content: Content.new(title: title))
        extension = attrs[:filename].split('.').last
        attrs[:kind] =
          case extension
          when 'pdf' then 'pdf'
          when 'jpg', 'jpeg', 'gif', 'png' then 'image'
          end

        if AssetFile.find_by(filename: attrs[:filename], asset_folder: attrs[:asset_folder]).present?
          filename = attrs[:filename]
          name, extension = filename.split('.')
          attrs[:filename] = "#{name}-#{SecureRandom.hex(2)}.#{extension}"
        end

        attrs[:width], attrs[:height] = FastImage.size(@file) if attrs[:kind] == 'image'
        attrs.delete(:file)
        attrs.delete(:title)
        super(attrs)
      end
    end
  end
end
