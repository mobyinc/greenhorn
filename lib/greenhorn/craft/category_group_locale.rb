require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class CategoryGroupLocale < BaseModel
      def self.table
        'categorygroups_i18n'
      end

      belongs_to :category_group, foreign_key: 'groupId'

      def source_locale
        Locale.find_by(locale: locale)
      end
    end
  end
end
