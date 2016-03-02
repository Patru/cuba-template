# encoding: UTF-8
require_relative 'user'

module Views
  module Admin
    module User
      class New < User
        def page_title
          'Create a new user'
        end

        def body_content
          form('/admin/user')
        end
      end
    end
  end
end
