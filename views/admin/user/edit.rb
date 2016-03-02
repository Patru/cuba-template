# encoding: UTF-8
require_relative 'user'

module Views
  module Admin
    module User
      class Edit < User
        def page_title
          "Edit user #{user.name}"
        end

        def body_content
          unless user.errors.empty?
            div :class => 'error-messages' do
              ul do
                user.errors.full_messages.each do |message|
                  li message
                end
              end
            end
          end
          form(user.show_path, 'Save', 'put')
        end
      end
    end
  end
end
