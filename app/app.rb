require 'bundler/setup'
require 'active_record'
require 'activerecord-import'
require 'activerecord-import/base'

require 'scrapper'

PROJECT_ROOT = File.dirname(File.absolute_path(__FILE__))
Dir.glob(PROJECT_ROOT + "/models/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/../lib/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/models/contexts/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/service/*.rb").each { |f| require f }
#Dir.glob(PROJECT_ROOT + "/workers/*.rb").each { |f| require f }

connection_details = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(connection_details)
