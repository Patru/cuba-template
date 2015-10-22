require_relative 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'database_cleaner'

DatabaseCleaner[:sequel, {connection: ::DB}].clean_with(:truncation)

class SequelSpec < Minitest::Spec

  def run(*args, &block)
    DatabaseCleaner.cleaning do
      super
    end
  end
end