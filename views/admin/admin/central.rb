# encoding: UTF-8

module Views
  module Admin
    module Admin
      class Central < Page
        needs :admin

        def page_title
          'Admin Central'
        end
        def body_content
          text "Hello #{admin.name} this is your central dashboard"

        end
      end
    end
  end
end

