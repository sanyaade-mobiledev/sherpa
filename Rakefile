require 'rake/testtask'

task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << '.'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc 'Mock config file used for testing and debugging'
task :probe do
  system "./bin/sherpa -i ./test/config/config.yaml"
end

namespace :preview do
  desc 'Preview examples from a yaml file'
  task :yaml do
    system "./bin/sherpa -i ./test/config/preview.yaml"
  end

  desc 'Preview examples from a json file'
  task :json do
    system "./bin/sherpa -i ./test/config/preview.json"
  end
end

