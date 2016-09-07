require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class SectionLocale < BaseModel
      def self.table
        'sections_i18n'
      end

      belongs_to :section, foreign_key: 'sectionId'
    end
  end
end
