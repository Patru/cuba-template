# Configuration for test environment
require 'fileutils'

ENV['DATABASE_URL'] = "sqlite://#{File.join(__dir__, "..", "db", "test.db")}"

if Kernel.const_defined? :Capybara
  Capybara.save_and_open_page_path = File.join(File.dirname(__FILE__), '..', 'tmp', 'capybara')
  unless File.directory?(Capybara.save_and_open_page_path)
    FileUtils.mkdir_p(Capybara.save_and_open_page_path)
  end
end
