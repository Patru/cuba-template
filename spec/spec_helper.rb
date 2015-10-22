# encoding: UTF-8
ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.setup
Bundler.require

require "cuba"
require 'minitest/pride'
require 'minitest/autorun'
require 'minitest/spec'
require 'pathname'

class Cuba
  def self.tmp_dir
    Pathname.new(__dir__,).join('..', 'tmp').expand_path
  end
end
#require 'rack/test'
#
#class MiniTest::Spec
#  include Rack::Test::Methods
#end

