# encoding: UTF-8
require 'sequel/model'
require 'forme'

class User < Sequel::Model
  plugin :forme
end