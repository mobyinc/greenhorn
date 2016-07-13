require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class AssetFolder < BaseModel
      def self.table
        'assetfolders'
      end

      has_many :asset_files, foreign_key: 'folderId'
      belongs_to :asset_source, foreign_key: 'sourceId'
      delegate :path, to: :asset_source
    end
  end
end
