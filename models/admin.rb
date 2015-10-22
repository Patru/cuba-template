# encoding: UTF-8
require 'sequel/model'
require 'shield'
require 'forme'

class Admin < Sequel::Model
  include Shield::Model
  plugin :validation_helpers
  plugin :forme

  #virtual attribute for validation
  def password
    @password
  end

  def password=(password)
    @password=password
    super
  end

  def validate
    super
    validates_presence [:name, :email]
    create_unique_random_token
    # we put this here to make sure all valid admins have a valid token
    if crypted_password.blank?
      errors.add(:password, 'can not be empty')
    end
    if new?
      unless password.nil?
        errors.add(:password, 'must be at least 8 characters long') if password.length < 8
        errors.add(:password, 'must contain a number') unless /[0-9]/ =~ password
        errors.add(:password, 'must contain a lower case character') unless /[a-z]/ =~ password
        errors.add(:password, 'must contain an upper case character') unless /[A-Z]/ =~ password
      end
    end
  end

  def create_unique_random_token
    if token.blank?
      loop do
        self.token=SecureRandom.urlsafe_base64(15)
        break unless Admin[token:token]
        # try again if it is already there (way unlikely)
      end
    end
  end

  def self.fetch token
    Admin[token:token]
  end

  def login_path
    "/admin/#{token}"
  end

  def show_path
    "/admin/show/#{id}"
  end

  def edit_path
    "/admin/edit/#{id}"
  end
end