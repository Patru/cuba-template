# encoding: UTF-8
require_relative '../models/Admin'
require_relative '../models/user'
require_relative '../views/admin/user/all'
require_relative '../views/forbidden_request'

class UserRoutes < Cuba
  define do
    on get do
      on 'index' do
        res.write forti(Views::Admin::User::Index, users:User.all)
      end

      on 'new' do
        res.write forti(Views::Admin::User::New, user:User.new)
      end

      on ':id' do |id|
        usr=User[:id]
        if usr
          on root do
            res.write forti(Views::Admin::User::Show, user:usr)
          end
          on 'edit' do
            res.write forti(Views::Admin::User::Edit, user:usr)
          end
        else
          flash[:error]='Could not find user'
          res.redirect '/admin/user/index'
        end
      end
    end

    on post, root, param('user') do |user|
      usr = User.new(user)
      if usr.save
        res.redirect usr.show_path
      else
        res.write forti(Views::Admin::User::New, user:usr)
      end
    end

    on put, ':id', param('user') do |id, user|
      usr=User[id:id]
      if usr
        usr.set_fields(user, ['name', 'email'])
        if usr.valid? && usr.save
          res.write forti(Views::Admin::User::Show, user:usr)
        else
          flash[:error]="user could not be saved"
          res.write forti(Views::Admin::User::Edit, user:usr)
        end
      else
        flash[:error]='Could not find user #{id}'
        res.redirect '/admin/user/index'
      end
    end
  end

end