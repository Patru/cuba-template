%w{ rubygems bundler find rake/testtask}.each { |lib| require lib }

task :default => [:spec, :integration]

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end

Rake::TestTask.new(:integration) do |t|
  t.test_files = FileList['spec/**/*_integration.rb']
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require_relative 'config/environment'
    require "sequel"
    Sequel.extension :migration
    puts "connecting to db #{ENV['DATABASE_URL']} while raking"
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end