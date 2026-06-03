require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :request) do
    DatabaseCleaner.start
    host! 'localhost'
  end

  config.before(:each, type: :controller) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
