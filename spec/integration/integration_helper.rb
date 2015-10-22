# encoding: UTF-8

require_relative "../sequel_spec_helper"
require_relative "../../routes/default"

require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara_minitest_spec'
require 'capybara-screenshot/minitest_plugin'
require 'minitest-metadata'
require 'rack/test'
require 'pony'    # need this to let email-spec work its wonders
require 'email-spec'

Capybara.app = Cuba
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :webkit
Capybara::Screenshot.prune_strategy = { keep: 6 }
Capybara.save_and_open_page_path = Cuba.tmp_dir.join('capybara')
unless File.directory?(Capybara.save_and_open_page_path)
  FileUtils.mkdir_p(Capybara.save_and_open_page_path)
end

class IntegrationSpec < SequelSpec
  include Capybara::DSL
  include Rack::Test::Methods
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Capybara::Screenshot::MinitestPlugin

  def app     # for Rack::Test
    Capybara.app
  end

  before do
    if metadata[:js]
      Capybara.current_driver = Capybara.javascript_driver
      DatabaseCleaner[:sequel, {connection: ::DB}].strategy = :truncation
    else
      Capybara.current_driver = Capybara.default_driver
      DatabaseCleaner[:sequel, {connection: ::DB}].strategy = :transaction
    end
  end

  def create_dummy_admin
    adm=Admin.new(name:'Dummy Admin', email: 'dummy@example.com', password: '12345xYz')
    adm.save
    adm
  end
  # no reset in #after required since all integration test will be run self contained

  def login_admin admin, password
    visit admin.login_path
    within 'form' do
      fill_in 'Password:', with: password
      click_button 'Log in'
    end
  end
end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end