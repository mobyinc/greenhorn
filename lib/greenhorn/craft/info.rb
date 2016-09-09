require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class Info < BaseModel
      class << self
        def table
          'info'
        end

        def value(key)
          first.send(key)
        end
      end
    end
  end
end
