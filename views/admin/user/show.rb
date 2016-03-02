# encoding: UTF-8
require_relative '../../page'

module Views
  module Admin
    module User
      class Show < Page
        needs :user
        def user_detail
          table class:'user' do
            tbody do
              tr do
                td 'Name:'
                td user.name
              end
              tr do
                td 'Email:'
                td user.email
              end
            end
          end
        end

        def item_navigation
          nav 'class' =>'item' do
            ul do
              li do
                a href:user.edit_path do
                  text 'Edit'
                end
              end
=begin            li do
              a href:user.delete_path do
                text 'Delete'
              end
=end
            end
          end
        end

        def page_title
          "Details for user #{user.name}"
        end

        def body_content
          user_detail
          item_navigation
        end
      end
    end
  end
end
