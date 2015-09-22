# encoding: UTF-8
require_relative 'page'

class HelloPage < Page
  def page_title
    'Hello world page'
  end

  def body_content
    p 'Hello world!'
  end
end