# encoding: UTF-8
require_relative 'integration_helper'

class HomeIntegration < IntegrationSpec
  it "has a home page" do
    visit "/"
    page.must_have_text "Hello world!"
    page.must_have_link "Home"
    page.click_link "About"
    page.must_have_title "About us"
  end
end