require 'rake/testtask'

task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc 'Mock config.yaml file used for testing and debugging'
task :probe do
  system "./bin/sherpa -i ./test/config/config.yaml"
end

desc 'Mock config.json file used for testing and debugging'
task :probe_json do
  system "./bin/sherpa -i ./test/config/config.json"
end

desc 'Mock config.yaml file and output results to the cli'
task :debug do
  system "./bin/sherpa -i ./test/config/config.yaml -d"
end

