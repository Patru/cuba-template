# encoding: UTF-8
ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.setup
Bundler.require

require "cuba"
require 'minitest/pride'
require 'minitest/autorun'
require 'minitest/spec'
#require 'rack/test'
#require 'capybara_minitest_spec'
#
#class MiniTest::Spec
#  include Rack::Test::Methods
#end

