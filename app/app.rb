require 'bundler/setup'
require 'active_record'
require 'activerecord-import'
require 'activerecord-import/base'

require 'scrapper'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/models/*.rb").each { |f| require f }
Dir.glob(project_root + "/lib/*.rb").each { |f| require f }
Dir.glob(project_root + "/models/contexts/*.rb").each { |f| require f }
Dir.glob(project_root + "/workers/*.rb").each { |f| require f }

connection_details = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(connection_details)