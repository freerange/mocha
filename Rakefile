require 'rubygems'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/sshpublisher'

module Mocha
  VERSION = "0.4.0"
end

desc "Default task is currently to run all tests"
task :default => :test_all

desc "Run all tests"
task :test_all do
  $: << "#{File.dirname(__FILE__)}/test"
  require 'test/all_tests'
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README'
  task.title = 'Mocha'
  task.rdoc_dir = 'doc'
  task.template = "html_with_google_analytics"
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README', 'RELEASE', 'COPYING', 'MIT-LICENSE', 'agiledox.txt', 'lib/mocha/auto_verify.rb', 'lib/mocha/mock_methods.rb', 'lib/mocha/expectation.rb', 'lib/mocha/object.rb')
end
task :rdoc => :examples

desc "Upload RDoc to RubyForge"
task :publish_rdoc => [:rdoc, :examples] do
  Rake::SshDirPublisher.new("jamesmead@rubyforge.org", "/var/www/gforge-projects/mocha", "doc").upload
end

desc "Generate agiledox-like documentation for tests"
file 'agiledox.txt' do
  File.open('agiledox.txt', 'w') do |output|
    tests = FileList['test/**/*_test.rb']
    tests.each do |file|
      m = %r".*/([^/].*)_test.rb".match(file)
      output << m[1]+" should:\n"
      test_definitions = File::readlines(file).select {|line| line =~ /.*def test.*/}
      test_definitions.sort.each do |definition|
        m = %r"test_(should_)?(.*)".match(definition)
        output << " - "+m[2].gsub(/_/," ") << "\n"
      end
    end
  end
end

desc "Convert example ruby files to syntax-highlighted html"
task :examples do
  require 'coderay'
  mkdir_p 'doc/examples'
  File.open('doc/examples/coderay.css', 'w') do |output|
    output << CodeRay::Encoders[:html]::CSS.new.stylesheet
  end
  ['mocha', 'stubba', 'misc'].each do |filename|
    File.open("doc/examples/#{filename}.html", 'w') do |file|
      file << "<html>"
      file << "<head>"
      file << %q(<link rel="stylesheet" media="screen" href="coderay.css" type="text/css">)
      file << "</head>"
      file << "<body>"
      file << CodeRay.scan_file("examples/#{filename}.rb").html.div
      file << "</body>"
      file << "</html>"
    end
  end
end

Gem::manage_gems

specification = Gem::Specification.new do |s|
	s.name   = "mocha"
  s.summary = "Mocking and stubbing library"
	s.version = Mocha::VERSION
	s.author = 'James Mead'
	s.description = <<-EOF
    Mocking and stubbing library with JMock/SchMock syntax, which allows mocking and stubbing of methods on real (non-mock) classes.
  EOF
	s.email = 'mocha-developer@rubyforge.org'
  s.homepage = 'http://mocha.rubyforge.org'
  s.rubyforge_project = 'mocha'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'COPYING']
  s.rdoc_options << '--title' << 'Mocha' << '--main' << 'README' << '--line-numbers'
                         
  s.autorequire = 'mocha'
  s.files = FileList['{lib,test,examples}/**/*.rb', '[A-Z]*'].exclude('TODO').to_a
	s.test_file = "test/all_tests.rb"
end

Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = true
	 package.need_tar = true
end

task :verify_user do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
end

task :verify_password do
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

desc "Publish package files on RubyForge."
task :publish_packages => [:verify_user, :verify_password, :package] do
  require 'meta_project'
  require 'rake/contrib/xforge'
  release_files = FileList[
    "pkg/mocha-#{Mocha::VERSION}.gem",
    "pkg/mocha-#{Mocha::VERSION}.tgz",
    "pkg/mocha-#{Mocha::VERSION}.zip"
  ]

  Rake::XForge::Release.new(MetaProject::Project::XForge::RubyForge.new('mocha')) do |release|
    release.user_name = ENV['RUBYFORGE_USER']
    release.password = ENV['RUBYFORGE_PASSWORD']
    release.files = release_files.to_a
    release.release_name = "Mocha #{Mocha::VERSION}"
    release.release_changes = ''
    release.release_notes = ''
  end
end
