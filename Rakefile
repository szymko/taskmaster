require 'bundler/setup'
require_relative './app/app'

namespace :db do

  desc "Migrate the db"
  task :migrate do
    Connection.establish()
    p Page.inspect
    ActiveRecord::Migrator.migrate("db/migrate/")
  end

  task :rollback do
    Connection.establish()
    ActiveRecord::Migrator.rollback("db/migrate/")
  end

  desc "Create the db"
  task :create do
    connection_details = Connection.config()
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc "Drop the db"
  task :drop do
    connection_details = Connection.config()
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end

  desc "Drop, create and migrate"
  task :reinst => [:drop, :create, :migrate] do
    p "TA DA!"
  end

  desc "Destroy pages, page_contents, contexts and page_contexts"
  task :destroy do
    Page.destroy_all
    Context.destroy_all
    PageContextRelation.destroy_all
  end
end
