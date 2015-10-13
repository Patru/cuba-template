# encoding: UTF-8
require_relative '../../page'

module Views
  module Admin
    module Admin
      class Please < Page

        def page_title
          'Admin link to log in'
        end

        def body_content
          text 'Thanks for using our application, please use the admin link to log in'
        end

      end
    end
  end
end