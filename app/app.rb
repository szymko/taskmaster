require 'bundler/setup'
require 'scrapper'
require_relative 'connection'
Connection.establish()

PROJECT_ROOT = File.dirname(File.join(File.dirname(__dir__), '/../'))
Dir.glob(PROJECT_ROOT + "/app/models/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/lib/**/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/app/workers/*.rb").each { |f| require f }

TaskmasterConfig = YAML.load_file(PROJECT_ROOT + '/config/config.yml').deep_symbolize_keys
