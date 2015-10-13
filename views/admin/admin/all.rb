Dir["#{__dir__}/**/*.rb"].each do |view_file|
  require view_file
end
