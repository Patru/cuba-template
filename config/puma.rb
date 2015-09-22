workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 9234
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  puts "booting worker and connecting to database using #{database_url}"
end