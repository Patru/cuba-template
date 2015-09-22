require "cuba"
require "cuba/safe"
require "rack/flash"
require "cuba/assets"
require File.expand_path(File.join('..', 'plugins', 'forti'), __dir__)
require_relative '../plugins/helpers'
require_relative '../views/hello'
require_relative '../views/hello_page'
require_relative '../views/about'

Cuba.use Rack::Session::Cookie, :secret => "JyaLlCpjl9P4VWJVH1TYCE3LiepuclESHqTpCt3YiJlk"
Cuba.use Rack::Flash, flash_app_class: Cuba, sweep: true

Cuba.plugin Cuba::Safe
Cuba.plugin Forti
Cuba.plugin Helpers
Cuba.plugin Cuba::Assets

Cuba.define do
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