require "cuba"
require "cuba/safe"
require "rack/flash"
require "cuba/assets"
require "rack/methodoverride"
require 'shield'
require File.expand_path(File.join('..', 'plugins', 'forti'), __dir__)
require_relative '../plugins/helpers'
require_relative '../views/hello'
require_relative '../views/hello_page'
require_relative '../views/about'
Dir["./routes/**/*.rb"].each  { |route| require route }

Cuba.use Rack::Session::Cookie, :secret => cookie_secret
Cuba.use Rack::Flash, flash_app_class: Cuba, sweep: true
Cuba.use Rack::MethodOverride

Cuba.plugin Cuba::Safe
Cuba.plugin Forti
Cuba.plugin Helpers
Cuba.plugin Cuba::Assets
Cuba.plugin Shield::Helpers

Cuba.define do
  #puts "in root, resolving #{env["PATH_INFO"]} through #{env['REQUEST_METHOD']}"
  on csrf.unsafe? do
    csrf.reset!

    res.status = 403
    res.write forti(Views::ForbiddenRequest, url: env['SCRIPT_NAME']+env['PATH_INFO'])

    halt(res.finish)
  end

  on 'admin' do
    run AdminRoutes
  end

  on get do
    on 'assets' do
      run sprocket_assets_server
    end
    on 'hello-page.html' do
      res.write forti(HelloPage)
    end
    on 'hello.html' do
      res.write forti(Views::Hello)
    end
    on 'hello.txt' do
      res.write "world! (#{env["RACK_ENV"]})"
    end
    on 'about' do
      res.write forti(Views::About)
    end

    on root do
      res.redirect '/hello-page.html'
    end
  end
end