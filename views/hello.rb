# encoding: UTF-8
require 'fortitude'

 module Views
  class Hello < Fortitude::Widget
    doctype :html5
    def content
      h1 "Hello World!"
    end
  end
end
