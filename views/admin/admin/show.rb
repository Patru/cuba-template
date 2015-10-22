# encoding: UTF-8
require_relative '../../page'

module Views
  module Admin
    module Admin
      class Show < Page
        needs :admin
        def admin_detail
          table class:'admin' do
            tbody do
              tr do
                td 'Name:'
                td admin.name
              end
              tr do
                td 'Email:'
                td admin.email
              end
              tr do
                td 'Token:'
                td admin.token
              end
            end
          end
        end

        def page_title
          "Details for admin #{admin.name}"
        end

        def body_content
          admin_detail
        end
      end
    end
  end
end
