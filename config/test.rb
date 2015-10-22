# Configuration for test environment
require 'fileutils'

ENV['DATABASE_URL'] = "sqlite://#{File.join(__dir__, "..", "db", "test.db")}"
ENV['COOKIE_SECRET'] = 'test non-secret'
