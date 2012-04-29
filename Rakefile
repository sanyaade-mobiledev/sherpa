require 'rake/testtask'

task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << '.'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

