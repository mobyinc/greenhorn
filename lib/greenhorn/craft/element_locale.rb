require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class ElementLocale < BaseModel
      self.table_name = 'elements_i18n'
      belongs_to :element, foreign_key: 'elementId'
      before_save do
        section_locale = element.entry.try(:section).try(:section_locale)
        if section_locale.present? && section_locale.urlFormat.present?
          self.uri = section_locale.urlFormat.sub '{slug}', slug
        end
      end
    end
  end
end
