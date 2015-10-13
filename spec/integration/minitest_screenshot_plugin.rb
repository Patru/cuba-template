require "capybara-screenshot"

module Capybara::Screenshot::MinitestPlugin

  def before_setup
    super
    Capybara::Screenshot.final_session_name = nil
  end

  def after_teardown
    super
    if Capybara::Screenshot.autosave_on_failure && !passed?
      Capybara.using_session(Capybara::Screenshot.final_session_name) do
        filename_prefix = Capybara::Screenshot.filename_prefix_for(:minitest, self)

        saver = Capybara::Screenshot::Saver.new(Capybara, Capybara.page, true, filename_prefix)
        saver.save
        saver.output_screenshot_path
      end
    end
  end
end

begin
  Capybara::Screenshot.class_eval do
    register_filename_prefix_formatter(:minitest) do |test|
      "screenshot-#{test.name.gsub(" ", "+")}"
    end
  end
end