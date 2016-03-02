# encoding: UTF-8
require_relative '../../page'

module Views
  module Admin
    module User
      class User < Page
        needs :user
        def form action, button='Create', method='post'
          frm= Forme.form(user, {action: action, method: 'post'},
              hidden_tags: [{_method: method}, csrf_token]) do |f|
              f.inputs([:email, :name], legend: 'User data') do
                f.input(:password, type: :password)
                f.button(value: button, name: 'send')
              end
            end
          rawtext frm.to_s
        end
      end
    end
  end
end
