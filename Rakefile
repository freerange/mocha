desc "Default task is currently to run all tests"
task :default => :test_all

desc "Run all tests"
task :test_all do
  $: << "#{File.dirname(__FILE__)}/test"
  require 'test/all_tests'
end