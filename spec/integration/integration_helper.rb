# encoding: UTF-8

require_relative "../sequel_spec_helper"
require_relative "../../routes/default"

require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara_minitest_spec'
require 'capybara-screenshot/minitest_plugin'
require 'minitest-metadata'
require 'pony'
require 'email-spec'

Capybara.app = Cuba
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :webkit
Capybara::Screenshot.prune_strategy = { keep: 6 }

class IntegrationSpec < SequelSpec
  include Capybara::DSL
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Capybara::Screenshot::MinitestPlugin

  before do
    if metadata[:js]
      Capybara.current_driver = Capybara.javascript_driver
      DatabaseCleaner[:sequel, {connection: ::DB}].strategy = :truncation
    else
      Capybara.current_driver = Capybara.default_driver
      DatabaseCleaner[:sequel, {connection: ::DB}].strategy = :transaction
    end
  end

  # no reset in #after required since all integration test will be run self contained
end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end