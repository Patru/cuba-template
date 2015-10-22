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
          nav_admin
          text "Hello #{admin.name} this is your central dashboard"

        end

        def nav_admin
          nav class:'admin' do
            a href:'/admin/index' do
              text 'Admins'
            end
          end
        end
      end
    end
  end
end

