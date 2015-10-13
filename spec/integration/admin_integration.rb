require_relative 'integration_helper'
require "minitest/matchers_vaccine"
require "email_spec"

class AdminIntegration < IntegrationSpec
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Minitest::Assertions

  it "redirects to admin creation as long as no admin exists" do
    visit '/admin'
    current_path.must_equal '/admin/new'
    visit '/admin/hell'
    current_path.must_equal '/admin/new'
    visit '/admin/central'
    current_path.must_equal '/admin/new'
  end

  it "can create a new admin" do
    visit '/admin/new'
    page.must_have_title 'Create a new Admin'
    within 'form' do
      fill_in 'admin_email', with:'admin@example.com'
      fill_in 'admin_name', with:'A boring Admin'
      fill_in 'admin_password', with:'non_really1'
      click_button 'Create'
    end
    page.must_have_title 'Admin link to log in'
    deliveries.wont_be_empty
    @subject=deliveries.last

    must deliver_to('admin@example.com')
    must have_body_text('A boring Admin')
    must have_body_text /http:\/\/www.example.com/

    /http:\/\/www.example.com(?<link>.*)$/ =~ @subject.body.to_s
    visit link
    page.must_have_title 'Admin login'
    page.must_have_text 'Hello A boring Admin'
    within 'form' do
      fill_in 'Password', with: 'non_really1'
      click_button 'Log in'
    end
    page.must_have_title 'Admin Central'
    click_link "Home"
    page.wont_have_title 'Admin Central'
    visit '/admin/central'
    page.must_have_title 'Admin Central'
    current_path.must_equal '/admin/central'
  #  fail "that's how far I am"

  end
end
