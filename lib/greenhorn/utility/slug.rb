module Greenhorn
  module Utility
    class Slug
      def initialize(string, type = :hyphen)
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
