$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'database_cleaner'
require 'greenhorn'

connection = Greenhorn::Connection.new(
  prefix: 'craft',
  host: 'localhost',
  username: 'root',
  password: 'password',
  database: 'greenhorn_test'
)

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    statements = File.read(File.expand_path('../greenhorn_test.sql', __FILE__)).split("\n\n")
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute('SET foreign_key_checks = 0;')
      statements.each do |stmt|
        begin
          ActiveRecord::Base.connection.execute(stmt)
        rescue ActiveRecord::StatementInvalid
          print ''
        end
      end
    end
  end

  config.before(:each) do
    @connection = connection
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
