require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class OrderStatusEmail < BaseModel
      class << self
        def table
          'commerce_orderstatus_emails'
        end
      end

      belongs_to :email, foreign_key: 'emailId', class_name: 'Email'
      belongs_to :status, foreign_key: 'statusId', class_name: 'OrderStatus'
    end
  end
end
