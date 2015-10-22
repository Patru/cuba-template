# encoding: UTF-8
require_relative '../../page'

#Forme.add_hidden_tag do |tag|
#  if defined?(::Cuba::Safe) && (form = tag.form) && (env = form.opts[:env]) && tag.attr[:method].to_s.upcase == 'POST'
#    {'csrf_token'=>Csrf.token(env)}
#  end
#end

module Views
  module Admin
    module Admin
      class Admin < Page
        needs :admin
        def form action, button='Create', method='post'
          frm= Forme.form(admin, {action: action, method: 'post'},
              hidden_tags: [{_method: method, 'admin[token]':admin.token}, csrf_token]) do |f|
              f.inputs([:email, :name], legend: 'Admin data') do
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
