# encoding: UTF-8
require_relative '../models/admin'
require_relative '../views/admin/admin/all'
require 'shield'

class AdminRoutes < Cuba
  def admins_exist?
    Admin.count > 0
  end

  define do
    # note that the following two are the only admin-routes we can reach as long as there is no administrator

    on authenticated(Admin) do
      adm=authenticated(Admin)
      res.write forti(Views::Admin::Admin::Central, admin:adm)
    end

    on get do
      on 'new' do
        a=Admin.new
        res.write forti(Views::Admin::Admin::New, admin:a)
      end

      on !admins_exist? do
        res.redirect '/admin/new'
      end

      on 'please' do
        res.write forti(Views::Admin::Admin::Please)
      end

      on ':token' do |token|
        adm=Admin[token:token]
        if adm
          res.write forti(Views::Admin::Admin::Login, admin:adm)
        else
          res.redirect '/admin/new'
        end
      end
    end

    on post do
      on 'create', param("admin") do |admin|
        new_admin=Admin.new(admin)
        if new_admin.save
          send_confirmation_email(new_admin)
          res.redirect 'please'
        else
          res.write forti(Views::Admin::Admin::New, admin:new_admin)
        end
      end

      on !admins_exist? do
        res.redirect '/admin/new'
      end

      on 'login', param('token'), param('admin') do |token, admin|
        if login(Admin, token, admin['password'])
          res.write forti(Views::Admin::Admin::Central, admin:Admin.fetch(token))
        else
          res.redirect '/admin/please'
        end
      end
    end

    on 'index' do
      admins=Admin.all
      if admins.count > 0
        save_and_open_page
        res.write forti(Views::Admin::Admin::Index)
      else
        res.redirect '/admin/please'
      end
    end

    on default do
      puts "routing by default"
      if Admin.count > 0
        res.redirect '/admin/please'
      else
        res.redirect '/admin/new'
      end
    end
  end

  def send_confirmation_email(admin)
    body=<<-END_OF_TEXT
Dear #{admin.name}

Please click on the link below to log in.

#{url('/admin/'+admin.token, true, false)}

thanks
    END_OF_TEXT

    Pony.mail(to: admin.email, from: 'somwhere.over@the-rain.bow',
              subject: 'Your admin link',
              body:body)
  end

end