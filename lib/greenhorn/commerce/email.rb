require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class Email < BaseModel
      class << self
        def table
          'commerce_emails'
        end
      end

      validates :name, :subject, :to, :templatePath, presence: true
    end
  end
end
