# After: http://paul.annesley.cc/2012/03/fast-rspec-slash-rails-tiered-spec-helper-dot-rb/
require 'yaml'
require 'active_record'

# ActiveRecord
Connection.establish('test')

# factory_girl
require_relative 'support/factory_girl'

# DatabaseCleaner
require 'database_cleaner'
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:transaction)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
 end
end

ActiveRecord::Base.send(:configurations=, YAML::load(ERB.new(IO.read('config/database.yml')).result))