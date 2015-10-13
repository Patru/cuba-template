# encoding: UTF-8
require_relative '../../page'

module Views
  module Admin
    module Admin
      class New < Page
        needs :admin
        def admin_form action, method='post'
          frm= Forme.form(admin, {action: action, method: 'post'},
                          hidden_tags: [{_method: method, token:admin.token}]) do |f|
            f.inputs([:email, :name], legend: 'Admin data') do
              f.input(:password, type: :password)
              f.button(value: "Create", name: 'send')
            end
          end
          rawtext frm.to_s
        end

        def page_title
          'Create a new Admin'
        end

        def body_content
          admin_form('/admin/create')
        end
      end
    end
  end
end
