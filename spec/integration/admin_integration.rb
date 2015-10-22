require_relative 'integration_helper'
require "minitest/matchers_vaccine"
require "email_spec"

class AdminIntegration < IntegrationSpec
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Minitest::Assertions

  before do
    Capybara.reset_sessions!    # make sure we loose all the cookies (putting this in after will prevent screenshots)
  end

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
      fill_in 'admin_password', with:'non_Really1'
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
      fill_in 'Password', with: 'non_Really1'
      click_button 'Log in'
    end
    page.must_have_title 'Admin Central'
    click_link "Home"
    page.wont_have_title 'Admin Central'
    visit '/admin/central'
    page.must_have_title 'Admin Central'
    current_path.must_equal '/admin/central'
  end

  describe 'behaviour if an admin exists' do
    before do
      @adm = create_dummy_admin
    end

    it 'logs in with the correct password' do
      visit '/admin'
      current_path.must_equal '/admin/please'
      visit @adm.login_path
      page.must_have_title 'Admin login'
      within 'form' do
        fill_in 'Password', with: '12345xYz'
        click_button 'Log in'
      end
      page.must_have_title 'Admin Central'

    end

    it 'produces a suitable message if the password is wrong' do
      visit @adm.login_path
      page.must_have_title 'Admin login'
      within 'form' do
        fill_in 'Password', with: 'hello_Dummy'
        click_button 'Log in'
      end
      page.must_have_title 'Admin link to log in'
      within 'div.flash .error' do
        page.must_have_text 'Login failed'
      end
    end

    it 'does not provide access to creating another admin' do
      visit '/admin/new'
      page.must_have_title 'Admin link to log in'
      within 'div.flash .error' do
        page.must_have_text 'Existing admin must create new admins'
      end
    end

    it 'wont allow a simple (fake) post to create a second admin if there is one already' do
      post '/admin/create', 'admin[name]' => 'A second Dummy admin',
           'admin[email]' => 'fake@none.org', 'admin[password]' => '654321dK'
      last_response.ok?.must_equal false
      last_response.status.must_equal 403
      last_response.body.must_include 'Access to /admin/create is not permitted in this context'
    end

    it 'can create a second admin' do
      login_admin @adm, '12345xYz'
      within 'nav.admin' do
        click_link 'Admins'
      end
      click_link 'New Admin'
      within 'form' do
        fill_in 'Email:', with: 'second@admin.com'
        fill_in 'Name:', with: 'Second Admin'
        fill_in 'Password:', with: '2ndTry34'
        click_button 'Create'
      end
      within 'nav.admin' do
        click_link 'Admins'
      end
      must_have_text 'Second Admin'
      click_link 'Second Admin'
      within 'table.admin' do
        must_have_text 'Name:'
        must_have_text 'Email:'
        must_have_text 'Token:'
      end
    end

    it 'flashes an error message if you access a nonexisting admin' do
      login_admin @adm, '12345xYz'
      visit "/admin/show/#{@adm.id+1}"
      within 'div.flash .error' do
        must_have_text 'This admin does not exist'
      end
    end

    it 'can display all admins' do
      login_admin @adm, '12345xYz'
      visit '/admin/index'
      page.must_have_title 'List of all admins'
      within 'table' do
        must_have_link @adm.name
      end
    end

    it 'can edit admin details' do
      login_admin @adm, '12345xYz'
      visit '/admin/index'
      page.must_have_title 'List of all admins'
      within 'table' do
        within find('tr', text: @adm.name) do
          click_link 'edit'
        end
      end
      must_have_title "Edit admin #{@adm.name}"
      within 'form' do
        fill_in 'Name:', with:'Changed Name'
        click_button 'Save'
      end
      #current_path.must_match /\/admin\/show/
      must_have_title 'Details for admin Changed Name'
    end
  end
end
