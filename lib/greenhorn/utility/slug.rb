module Greenhorn
  module Utility
    class Slug
      def initialize(string, type = :hyphen)
        @slug = string.downcase.strip
        @slug = if type == :hyphen
                  @slug.gsub(' ', '-').gsub(/[^\w-]/, '')
                else
                  @slug.gsub(' ', '_').gsub(/[^\w-]/, '')
                end
        @slug = @slug.gsub(/[^\w-]/, '')
      end

      def to_s
        @slug
      end
    end
  end
end
