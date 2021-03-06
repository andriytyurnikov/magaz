require 'database_cleaner'

DatabaseCleaner.strategy = :deletion
# DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  setup do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  self.use_transactional_tests = false
end
