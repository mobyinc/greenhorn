$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'database_cleaner'
require 'greenhorn'

connection = Greenhorn::Connection.new(
  prefix: 'craft',
  host: 'localhost',
  username: 'root',
  password: 'password',
  database: 'greenhorn_dev'
)

RSpec.configure do |config|
  config.before(:suite) { DatabaseCleaner.strategy = :transaction }

  config.before(:each) do
    DatabaseCleaner.start
    @connection = connection
  end

  config.after(:each) { DatabaseCleaner.clean }
end
