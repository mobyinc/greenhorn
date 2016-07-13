require 'active_record'
require 'greenhorn/utility/uid'

module Greenhorn
  class Model < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.abstract_class = true

    class << self
      def table
        table_name
      end

      def from_boolean(bool)
        bool ? 1 : 0
      end
    end

    def from_boolean(bool)
      bool ? 1 : 0
    end

    def craft_table_name
      table_name
    end

    before_create do
      self.uid = Utility::UID.new
      self.dateCreated = Time.now.utc

      self.postDate = Time.now.utc if respond_to?(:postDate)
    end

    before_save do
      self.dateUpdated = Time.now.utc
    end
  end
end
