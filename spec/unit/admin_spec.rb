# encoding: UTF-8
require_relative '../sequel_spec_helper'
require_relative '../../models/admin'

class AdminSpec < SequelSpec
  describe "an admin" do
    it "can create an invalid Admin without attributes" do
      adm=Admin.new
      adm.valid?.must_equal false
    end

    it "can create an invalid Admin with a name" do
      adm=Admin.new(name:"dummy name")
      adm.valid?.must_equal false
      adm.errors.count.must_equal 2
    end

    it "can create an invalid Admin with a e-mail" do
      adm=Admin.new(email:"dummy@example.com")
      adm.valid?.must_equal false
      adm.errors.count.must_equal 2
    end

    it 'can create an invalid Admin without password' do
      adm=Admin.new(name:"dummy name", email:"dummy@example.com")
      adm.valid?.must_equal false
      adm.errors.count.must_equal 1
      adm.errors.on(:password)[0].must_equal 'can not be empty'
    end

    describe "tests with passwords (comparatively slow)" do
      it 'can create an invalid Admin with an empty password' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 4
        adm.errors.on(:password)[0].must_equal 'must be at least 8 characters long'
      end

      it "can create an invalid Admin with a password" do
        adm=Admin.new(password:"1283567xV")
        adm.valid?.must_equal false
        adm.errors.count.must_equal 2
      end

      it 'can create an invalid Admin with a short password' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'12xV')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 1
        adm.errors.on(:password)[0].must_equal 'must be at least 8 characters long'
      end

      it 'can create an invalid Admin without a number' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'xVxVxVxV')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 1
        adm.errors.on(:password)[0].must_equal 'must contain a number'
      end

      it 'can create an invalid Admin without a lower chase char' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'12XVXVXV')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 1
        adm.errors.on(:password)[0].must_equal 'must contain a lower case character'
      end

      it 'can create an invalid Admin with an upper case char' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'12xvxvxv')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 1
        adm.errors.on(:password)[0].must_equal 'must contain an upper case character'
      end

      it 'wont accept a password without a number' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:'hello_Dummy')
        adm.valid?.must_equal false
        adm.errors.count.must_equal 1
        adm.errors.on(:password)[0].must_equal 'must contain a number'
      end

      it 'can create a valid Admin' do
        adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:"1283567xV")
        adm.valid?.must_equal true
        adm.crypted_password.wont_be_nil
      end

      describe 'a valid admin' do
        before do
          @adm=Admin.new(name:"dummy name", email:"dummy@example.com", password:"1283567xV")
          @adm.valid?.must_equal true
        end

        it 'has a token' do
          @adm.token.wont_be_nil
          @adm.token.length.must_be :>, 0
        end

        it 'knows its login_path' do
          @adm.login_path.wont_be_nil
          @adm.login_path.length.must_be :>, 0
        end
      end
    end
  end
end