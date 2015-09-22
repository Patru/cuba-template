# encoding: UTF-8
require_relative '../spec_helper'

class TemplateSpec < Minitest::Spec
  describe "a dummy template" do
    it "can succeed" do
      4.must_equal 2+2
    end
  end
end