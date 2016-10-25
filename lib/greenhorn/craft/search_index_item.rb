require 'greenhorn/commerce/base_model'

module Greenhorn
  module Craft
    class SearchIndexItem < BaseModel
      class << self
        def table
          'searchindex'
        end

        def index_asset(asset, locale_code)
          SearchIndexItem.delete_all(elementId: asset.element.id, locale: locale_code)
          SearchIndexItem.insert_index(
            asset.element.id,
            'filename',
            0,
            locale_code,
            asset.filename
          )
          SearchIndexItem.insert_index(
            asset.element.id,
            'title',
            0,
            locale_code,
            asset.title
          )
        rescue Exception => e
          logger.error("Error indexing asset #{e}")
        end

        def insert_index(elementId, attribute, fieldId, locale, keywords)
          sql = "INSERT INTO craft_searchindex (elementId, attribute, fieldId, locale, keywords) VALUES(#{elementId}, '#{attribute}', #{fieldId}, '#{locale}', '#{keywords}')"
          SearchIndexItem.connection.execute(sql)
        end
      end
    end
  end
end
