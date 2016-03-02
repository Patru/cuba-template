# encoding: UTF-8
require 'shield'
require 'pony'
require_relative '../models/admin'
require_relative '../views/admin/admin/all'
require_relative '../views/forbidden_request'
require_relative 'user_routes'

class AdminRoutes < Cuba
  def admins_exist?
    Admin.count > 0
  end

  define do
    # note that the following two are the only admin-routes we can reach as long as there is no administrator

    on authenticated(Admin) do
      on 'user' do
        run UserRoutes
      end
      adm=authenticated(Admin)
      on get do
        on 'logout' do
          logout(Admin)
          res.redirect '/admin/please'
        end

        on 'central' do
          res.write forti(Views::Admin::Admin::Central, admin:adm)
        end

        on 'index' do
          res.write forti(Views::Admin::Admin::Index, admins:Admin.all)
        end

        on 'new' do
          a=Admin.new
          res.write forti(Views::Admin::Admin::New, admin:a)
        end

        on 'show/:id' do |id|
          adm=Admin[id]
          if adm
            res.write forti(Views::Admin::Admin::Show, admin:adm)
          else
            flash[:error]='This admin does not exist'
            res.redirect '/admin/central'
          end
        end

        on 'edit/:id' do |id|
          adm=Admin[id]
          if adm
            res.write forti(Views::Admin::Admin::Edit, admin:adm)
          else
            flash[:error]='This admin does not exist'
            res.redirect '/admin/central'
          end
        end

        on default do
          puts "I am authenticated with #{session[:Admin]}, but I do not know what to get with #{env['PATH_INFO']} at #{env['SCRIPT_NAME']}"
          raise StandardError.new("I wanna know where this happens")
          res.redirect '/admin/central'
        end
      end

      on post do
        on 'create', param("admin") do |admin|
          new_admin=Admin.new(admin)
          if new_admin.save
            send_confirmation_email(new_admin)
            res.redirect '/admin/central'
          else
            res.write forti(Views::Admin::Admin::New, admin:new_admin)
          end
        end

        on default do
          puts "environment #{env} failed to resolve for post"
        end
      end

      on put, 'show/:id', param('admin') do |id, admin|
        adm=Admin[id]
        if adm.token.eql? admin['token']
          adm.name=admin['name']
          adm.email=admin['email']
          if adm.save
            res.write forti(Views::Admin::Admin::Show, admin:adm)
          else
            flash[:error]='Could not save admin'
            res.redirect '/admin/central'
          end
        else
          flash[:error]='Some things do not match up, request denied'
          res.redirect '/admin/central'
        end
      end

      on default do
        puts "environment #{env} failed to resolve while authenticated"
      end
    end

    on get do
      on 'new' do
        if !admins_exist?
          a=Admin.new
          res.write forti(Views::Admin::Admin::New, admin:a)
        else
          flash[:error]= 'Existing admin must create new admins'
          res.redirect '/admin/please'
        end
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
          puts "could not find admin with #{token}, will you new?"
          res.redirect '/admin/new'
        end
      end

      on default do
        res.redirect '/admin/please'
      end
    end

    on post do
      on 'create', param("admin") do |admin|
        if !admins_exist?   # all authenticated posts are caught above
          new_admin=Admin.new(admin)
          if new_admin.save
            send_confirmation_email(new_admin)
            res.redirect 'please'
          else
            res.write forti(Views::Admin::Admin::New, admin:new_admin)
          end
        else
          forbidden_request
        end

      end

      on !admins_exist? do
        res.redirect '/admin/new'
      end

      on 'login', param('token'), param('admin') do |token, admin|
        if login(Admin, token, admin['password'])
          res.write forti(Views::Admin::Admin::Central, admin:Admin.fetch(token))
        else
          flash[:error]='Login failed'
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

  def forbidden_request
    res.status=403
    res.write forti(Views::ForbiddenRequest, url: env['SCRIPT_NAME']+env['PATH_INFO'])
  end
end