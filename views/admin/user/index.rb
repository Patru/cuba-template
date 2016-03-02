# encoding: UTF-8


module Views
  module Admin
    module User
      class Index < Page
        needs :users

        def page_title
          'List of all users'
        end
        def body_content
          h1 page_title

          users_table
          a href:'/admin/user/new' do
            text 'New User'
          end
        end

        def users_table
          table 'class' => 'users' do
            thead do
              th 'Name'
              th 'E-mail'
              th colspan:2 do
                'Actions'
              end
            end
            tbody do
              users.each do |user|
                tr do
                  td do
                    #a href:user.show_path, title: 'show details' do
                      text user.name
                    #end
                  end
                  td user.email
                  td do
                    #a href:admin.edit_path, title: 'edit' do
                      text 'edit'
                    #end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
