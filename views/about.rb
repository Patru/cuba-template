# encoding: UTF-8
require_relative 'page'

module Views
  class About < Page
    def page_title
      'About us'
    end

    def body_content
      p 'Put something about us here'
      p do
        text 'find us on '
        a href: 'https://github.com/Patru/cuba-template' do
          text 'github'
        end
      end
    end
  end
end
