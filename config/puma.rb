workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 9234
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  db=Sequel.connect(database_url, test:true)
  # without testing the connection here an invalid connection will result when starting puma
  # (even more strangely, rackup will stell do, even with puma as the server)
end