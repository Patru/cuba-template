require 'sequel'

environment = ENV['RACK_ENV'] || 'development'

require File.join(File.dirname(__FILE__), environment)

def database_url
  @database_url ||= ENV['DATABASE_URL'] || 'sqlite://db/dummy.db'
  @database_url
end

def cookie_secret
  ENV['COOKIE_SECRET']
end

DB=Sequel.connect(database_url)
puts "connecting to database #{database_url}"
