# encoding: UTF-8
require_relative 'page'

module Views
  class ForbiddenRequest < Page
    needs :url
    def page_title
      'Forbidden request'
    end

    def body_content
      h2 "Access to #{url} is not permitted in this context"
    end
  end
end
