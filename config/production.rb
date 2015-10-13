# Configuration for production environment
require 'pony'

# make sure not to check in this file with any of your production secrets
# retrieve all of them from the environment (but do it here :-)
Pony.options = {
    :via => :smtp,
    :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'heroku.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
    }
}