require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class SectionLocale < BaseModel
      self.table_name = 'sections_i18n'
      belongs_to :section, foreign_key: 'sectionId'
    end
  end
end
