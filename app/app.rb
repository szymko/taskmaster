require 'bundler/setup'
#require 'active_record'
#require 'activerecord-import'
#require 'activerecord-import/base'
require 'scrapper'
require_relative 'connection'
Connection.establish()

PROJECT_ROOT = File.dirname(File.absolute_path(__FILE__))
Dir.glob(PROJECT_ROOT + "/models/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/../lib/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/service/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/workers/*.rb").each { |f| require f }
