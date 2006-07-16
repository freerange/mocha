desc "Default task is currently to run all tests"
task :default => :test_all

desc "Run all tests"
task :test_all do
  $: << "#{File.dirname(__FILE__)}/test"
  require 'test/all_tests'
end

require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

specification = Gem::Specification.new do |s|
	s.name   = "mocha"
  s.summary = "Mocking and stubbing library"
	s.version = "0.1"
	s.author = 'James Mead'
	s.description = <<-EOF
    Mocking and stubbing library with JMock/SchMock syntax, which allows mocking and stubbing of methods on real (non-mock) classes.
    Includes auto-mocking which magically provides mocks for undefined classes, facilitating unit tests with no external dependencies.
  EOF
	s.email = 'mocha-developer@rubyforge.org'
  s.homepage = 'http://mocha.rubyforge.org'
  s.rubyforge_project = 'mocha'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'COPYING']
  s.rdoc_options << '--title' << 'Mocha' << '--main' << 'README' << '--line-numbers'
                         
  s.autorequire = 'mocha'
  s.files = FileList['{lib,test}/**/*.rb'].to_a
	s.test_file = "test/all_tests.rb"
end

Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = true
	 package.need_tar = true
end