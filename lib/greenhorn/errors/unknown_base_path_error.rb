module Greenhorn
  module Errors
    class UnknownBasePathError < StandardError
      def initialize(asset_path)
        message = <<-eos
          {basePath} specified in asset path format but no base path set in Greenhorn

          The specified asset path was: `#{asset_path}`

          Set your base path when establishing a connection:

          Greenhorn::Connection.new(
            username: '...',
            password: '...',
            ...,
            basePath: '../my_relative_path'
          )
        eos
        super(message)
      end
    end
  end
end
