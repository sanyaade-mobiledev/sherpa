require 'rake/testtask'

task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc 'Run a single test file: ftest[filename_test.rb]'
task :ftest, :file do |t, arg|
  system "ruby -I.:lib:test test/#{arg[:file]}"
end

desc 'Debug the contents from running sherpa without any saved output'
task :debug do
  system "./bin/sherpa -i ./test/config/config.yml -d"
end

desc 'Generate html output from a mock config.yml file'
task :html do
  system "./bin/sherpa -i ./test/config/config.yml --html"
end

desc 'Generate json output from a mock config.yml file'
task :json do
  system "./bin/sherpa -i ./test/config/config.yml --json"
end

desc 'Generate a single markdown output from a mock config.yml file'
task :markdown do
  system "./bin/sherpa -i ./test/config/config.yml --markdown"
end

desc 'Generates all output types supported by sherpa'
task :outputs do
  system "./bin/sherpa -i ./test/config/config.yml --html --markdown --json"
end

