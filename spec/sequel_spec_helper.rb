require_relative 'spec_helper'
require File.expand_path('../config/environment', __dir__)

class SequelSpec < Minitest::Spec
  def run(*args, &block)
    result = nil
    Sequel::Model.db.transaction(:rollback=>:always, :auto_savepoint=>true){result = super}
    result
  end
end