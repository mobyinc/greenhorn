module Greenhorn
  module Utility
    class Slug
      def initialize(string, type = :hyphen)
        unless string.present?
          raise Greenhorn::Errors::MissingAttributeError, "Can't create slug without a string"
        end

        @slug = string.downcase.strip
        @slug = if type == :hyphen
                  @slug.tr(' ', '-').gsub(/[^\w-]/, '')
                else
                  @slug.tr(' ', '_').gsub(/[^\w-]/, '')
                end
        @slug = @slug.gsub(/[^\w-]/, '')
      end

      def to_s
        @slug
      end
    end
  end
end
