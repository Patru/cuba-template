# encoding: UTF-8

require_relative "../sequel_spec_helper"
require_relative "../../routes/default"

require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara_minitest_spec'
require 'pony'
require 'minitest/matchers_vaccine'
require 'email-spec'

Capybara.app = Cuba
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :webkit

class IntegrationSpec < SequelSpec
  include Capybara::DSL
  include EmailSpec::Helpers
  include EmailSpec::Matchers
end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end