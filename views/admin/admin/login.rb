# encoding: UTF-8

module Views
  module Admin
    module Admin
      class Login < Page
        needs :admin

        def page_title
          'Admin login'
        end
        def body_content
          text "Hello #{admin.name}, please log in with your password"
          frm= Forme.form(admin, {action: '/admin/login', method: 'post'},
                          hidden_tags: [csrf_token, {token:admin.token}]) do |f|
            f.inputs do
              f.input(:password, type: :password)
              f.button(value: "Log in", name: 'login')
            end
          end
          rawtext frm.to_s

        end
      end
    end
  end
end

