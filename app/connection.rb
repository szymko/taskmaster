require 'yaml'
require 'active_record'
require 'activerecord-import'
require 'activerecord-import/base'

module Connection

  def self.establish(environment = nil)
    ActiveRecord::Base.clear_all_connections!()
    ActiveRecord::Base.establish_connection(config(environment))
  end

  def self.config(environment = nil)
    config = load_config()
    env = environment || get_environment()
    config[env]
  end

  private

  def self.load_config()
    YAML::load_file(File.join(__dir__, '../config/database.yml'))
  end

  def self.get_environment()
    ENV['PROJECT_ENV'] || 'development'
  end
end
