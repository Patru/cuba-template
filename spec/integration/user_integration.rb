# encoding: UTF-8
require_relative 'integration_helper'

class UserIntegration < IntegrationSpec
  describe 'as an admin' do
    before do
      Capybara.reset_sessions!    # make sure we loose all the cookies (putting this in after will prevent screenshots)
      @dummy_admin = create_dummy_admin
      login_admin @dummy_admin, '12345xYz'
    end

    it 'can access an empty index' do
      visit '/admin/user/index'
      current_path.must_equal '/admin/user/index'
      page.must_have_title 'List of all users'
      within 'table.users' do
        wont_have_css 'tr'
      end
    end

    it 'can create a new user and show it' do
      visit '/admin/user/index'
      click_link 'New User'
      page.must_have_title 'Create a new user'
      within 'form.user' do
        fill_in 'Name', with:'first user'
        fill_in 'Email:', with:'first@user.org'
        fill_in 'Password', with: 'SchwapSchu'
        click_button 'Create'
      end
      current_path.must_match /\/admin\/user/
      page.must_have_title 'Details for user first user'
      within 'nav.item' do
        must_have_link 'Edit'
      end
    end

    describe 'with an existing user' do
      before do
        @usr = User.new(name: 'test user', email:'test@user.org', password:'123abcDE')
        @usr.save
      end

      it 'can edit the users name' do
        visit @usr.show_path
        click_link 'Edit'
        within 'form' do
          must_have_field 'Name', with:@usr.name
          fill_in 'Name', with:'new name'
          click_button 'Save'
        end
        current_path.must_match '/admin/user'
        within 'table.user' do
          must_have_text 'new name'
          wont_have_text 'test user'
        end
      end

      it 'validates the presence of the name' do
        visit @usr.edit_path
        within 'form' do
          fill_in 'Name', with:''
          click_button 'Save'
        end
        within 'div.flash .error' do
          must_have_text 'user could not be saved'
        end
        within 'div.error-messages' do
          must_have_text 'name is not present'
        end
      end

      it 'validates the presence of the email' do
        visit @usr.edit_path
        within 'form' do
          fill_in 'Email', with:''
          click_button 'Save'
        end
        within 'div.error-messages' do
          must_have_text 'email is not present'
        end
      end
    end
  end

end