require 'httparty'
require 'addressable'
require 'fog/aws'
require 'fog/local'
require 'fastimage'
require 'greenhorn/craft/base_model'
require 'greenhorn/craft/content_behaviors'

module Greenhorn
  module Craft
    class AssetFile < BaseModel
      def self.field_layout_association
        :asset_source
      end
      include ContentBehaviors

      class << self
        def table
          'assetfiles'
        end

        def file_contents_for(uri)
          if File.exist?(uri)
            File.read(uri)
          else
            uri = Addressable::URI.parse(uri)
            if uri.host.nil?
              raise Errors::InvalidFileError, "Invalid URL `#{uri}`"
            end
            HTTParty.get(uri, uri_adapter: Addressable::URI).to_s
          end
        rescue URI::InvalidURIError
          raise Errors::InvalidFileError, "Invalid file `#{uri}`: file must either be a local path or a URL"
        end

        def file_size_for(uri)
          file_contents_for(uri).size
        end

        def filename_for(uri)
          uri.split('/').last
        end

        def existing_file_for(uri)
          matching_filename = find_by(filename: filename_for(uri))
          return nil unless matching_filename.present? && matching_filename.size == file_size_for(uri)
          matching_filename
        end
      end

      belongs_to :asset_folder, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'

      delegate :title, to: :element

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
        when 'S3'
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

        file = dir.files.create(
          key: "#{asset_source.settings['subfolder']}/#{filename}",
          body: self.class.file_contents_for(@file),
          public: true,
          metadata: cache_headers
        )
        update(size: file.content_length)
      end

      # Instantiates a new asset file
      #
      # @param attrs [Hash]
      # @option attrs [AssetFolder] asset_folder The folder to place this file into
      # @option attrs [String] file A local path or URL to the file being added
      # @option attrs [String] filename (file.split('/').last) The filename to associate with the file
      # @option attrs [String] title (filename) The title to associate with the file
      # @option attrs [Hash] (...field_attrs) Values for any custom fields you've associated with the
      #   asset_folder's asset_source
      # @return [AssetFile]
      #
      # @example Initialize an asset file from a URL with custom fields
      #   AssetFile.new(
      #     asset_folder: AssetFolder.last,
      #     file: 'http://example.com/image.jpg',
      #     customField: 'customVal'
      #     customField2: 'customVal2'
      #   )
      def initialize(attrs)
        require_attributes!(attrs, %i(file asset_folder))

        @file = attrs[:file]
        attrs[:filename] ||= self.class.filename_for(@file)
        attrs[:asset_source] = attrs[:asset_folder].try(:asset_source)

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

      def assign_attributes(attrs)
        attrs[:title] ||= attrs[:filename]
        attrs[:element] = element || Element.create!(type: 'Asset', slug: attrs[:filename])

        super(attrs)
      end

      def to_h
        hash = super()
        hash[:url] = public_url
        hash
      end

      def public_url
        public_urls = asset_source.settings['publicURLs'] || asset_source.settings['publicUrls']
        return nil if asset_source.nil? || !public_urls
        folder = asset_folder.path
        folder << '/' unless folder.end_with?('/')
        "#{asset_source.settings['url']}#{asset_source.settings['urlPrefix']}#{asset_source.settings['subfolder']}#{folder}#{filename}"
      end
    end
  end
end
