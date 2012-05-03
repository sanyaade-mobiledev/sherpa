require 'rake/testtask'

task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << '.'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc 'Run a simple test on a single file'
task :simple do
  system "./bin/sherpa -i ./test/fixtures/config/config.yaml"
end

namespace :examples do
  desc 'Output examples from a yaml file'
  task :yaml do
  system "./bin/sherpa -i ./example/config/sherpa.yaml"
  end

  desc 'Output examples from a json file'
  task :json do
    system "./bin/sherpa -i ./example/config/sherpa.json"
  end
end

