# encoding: UTF-8
require 'sequel/model'
require 'shield'
require 'forme'

class Admin < Sequel::Model
  include Shield::Model
  plugin :validation_helpers
  plugin :forme

  def validate
    super
    validates_presence [:name, :email]
    create_unique_random_token
    # we put this here to make sure all valid admins have a valid token
  end

  def create_unique_random_token
    loop do
      self.token=SecureRandom.urlsafe_base64(15)
      break unless Admin[token:token]
      # try again if it is already there (unlikely)
    end
  end

  def self.fetch token
    Admin[token:token]
  end
end