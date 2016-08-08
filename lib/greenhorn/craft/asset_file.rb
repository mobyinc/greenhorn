require 'httparty'
require 'addressable'
require 'fog/aws'
require 'fog/local'
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
        case asset_source.type
        when 'Local'
          asset_path = asset_source.settings['path']
          if asset_path.include?('{basePath}')
            base_path = config.base_path
            raise Errors::UnknownBasePathError, asset_path if base_path.nil?
            asset_path.sub!('{basePath}', base_path)
          end

          # Extract the ultimate directory from the path for use w/ Fog
          path_directories =  asset_path.split('/')
          directory =         path_directories.pop
          asset_path =        path_directories.join('/')

          fog_settings = { provider: 'Local', local_root: asset_path }
        when 'AWS'
          fog_settings = {
            provider: 'AWS',
            aws_access_key_id: asset_source.settings['keyId'],
            aws_secret_access_key: asset_source.settings['secret'],
            region: asset_source.settings['location'],
            path_style: true
          }
          directory = asset_source.settings['bucket']
        end

        connection = Fog::Storage.new(fog_settings)
        dir = connection.directories.get(directory) || connection.directories.create(key: directory)
        expires = asset_source.settings['expires']
        cache_headers =
          if expires.present?
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
            { 'Cache-Control' => "max-age=#{cache_seconds}" }
          else
            {}
          end

        begin
          body = File.exist?(@file) ? File.read(@file) : HTTParty.get(@file, uri_adapter: Addressable::URI).to_s
        rescue URI::InvalidURIError
          raise Errors::InvalidFileError, "Invalid file `#{@file}`: file must either be a local path or a URL"
        end

        file = dir.files.create(
          key: "#{asset_source.settings['subfolder']}/#{filename}",
          body: body,
          public: true,
          metadata: cache_headers
        )
        update(size: file.content_length)
      end

      def initialize(attrs)
        require_attributes!(attrs, %i(file asset_folder))
        attrs[:asset_source] = attrs[:asset_folder].asset_source

        @file = attrs[:file]
        attrs[:filename] ||= @file.split('/').last

        non_field_attrs = %i(file asset_source asset_folder title).concat(self.class.column_names.map(&:to_sym))
        field_attrs = attrs.reject { |key, _value| non_field_attrs.include?(key) }
        field_attrs.each { |key, _value| attrs.delete(key) }
        content_attrs = field_attrs.merge(title: attrs[:title] || attrs[:filename])

        attrs[:element] = Element.create!(type: 'Asset', slug: attrs[:filename], content: Content.new(content_attrs))
        extension = attrs[:filename].split('.').last
        attrs[:kind] =
          case extension
          when 'pdf' then 'pdf'
          when 'jpg', 'jpeg', 'gif', 'png' then 'image'
          else 'pdf'
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
