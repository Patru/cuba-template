# encoding: UTF-8


module Views
  module Admin
    module Admin
      class Index < Page
        needs :admins

        def page_title
          'List of all admins'
        end
        def body_content
          h1 page_title

          admins_table
          a href:'/admin/new' do
            text 'New Admin'
          end
        end

        def admins_table
          table do
            thead do
              th 'Name'
              th 'E-mail'
              th colspan:2 do
                'Actions'
              end
            end
            tbody do
              admins.each do |admin|
                tr do
                  td do
                    a href:admin.show_path, title: 'show details' do
                      text admin.name
                    end
                  end
                  td admin.email
                  td do
                    a href:admin.edit_path, title: 'edit' do
                      text 'edit'
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
end
