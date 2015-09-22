require 'sequel'

environment = ENV['RACK_ENV'] || 'development'

require File.join(File.dirname(__FILE__), environment)

def database_url
  @database_url ||= ENV['DATABASE_URL'] || 'sqlite://db/dummy.db'
  @database_url
end

Sequel.connect(database_url)
#Sequel.extension :migration