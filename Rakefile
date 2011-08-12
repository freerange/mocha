require "bundler"
Bundler::GemHelper.install_tasks
require "bundler/setup"

require 'rdoc/task'
require 'rake/testtask'

desc "Run all tests"
task 'default' => ['test', 'test:performance']

desc "Run unit & acceptance tests"
task 'test' => ['test:units', 'test:acceptance']

namespace 'test' do

  unit_tests = FileList['test/unit/**/*_test.rb']
  all_acceptance_tests = FileList['test/acceptance/*_test.rb']
  ruby186_incompatible_acceptance_tests = FileList['test/acceptance/stub_class_method_defined_on_*_test.rb'] + FileList['test/acceptance/stub_instance_method_defined_on_*_test.rb']
  ruby186_compatible_acceptance_tests = all_acceptance_tests - ruby186_incompatible_acceptance_tests

  desc "Run unit tests"
  Rake::TestTask.new('units') do |t|
    t.libs << 'test'
    t.test_files = unit_tests
    t.verbose = true
    t.warning = true
  end

  desc "Run acceptance tests"
  Rake::TestTask.new('acceptance') do |t|
    t.libs << 'test'
    if defined?(RUBY_VERSION) && (RUBY_VERSION >= "1.8.7")
      t.test_files = all_acceptance_tests
    else
      t.test_files = ruby186_compatible_acceptance_tests
    end
    t.verbose = true
    t.warning = true
  end

  # require 'rcov/rcovtask'
  # Rcov::RcovTask.new('coverage') do |t|
  #   t.libs << 'test'
  #   t.test_files = unit_tests + acceptance_tests
  #   t.verbose = true
  #   t.warning = true
  #   t.rcov_opts << '--sort coverage'
  #   t.rcov_opts << '--xref'
  # end

  desc "Run performance tests"
  task 'performance' do
    require File.join(File.dirname(__FILE__), 'test', 'acceptance', 'stubba_example_test')
    require File.join(File.dirname(__FILE__), 'test', 'acceptance', 'mocha_example_test')
    iterations = 1000
    puts "\nBenchmarking with #{iterations} iterations..."
    [MochaExampleTest, StubbaExampleTest].each do |test_case|
      puts "#{test_case}: #{benchmark_test_case(test_case, iterations)} seconds."
    end
  end

end

def benchmark_test_case(klass, iterations)
  require 'benchmark'

  if defined?(MiniTest)
    MiniTest::Unit.output = StringIO.new
    Benchmark.realtime { iterations.times { |i| MiniTest::Unit.new.run(klass) } }
  else
    load 'test/unit/ui/console/testrunner.rb' unless defined?(Test::Unit::UI::Console::TestRunner)
    unless $silent_option
      begin
        load 'test/unit/ui/console/outputlevel.rb' unless defined?(Test::Unit::UI::Console::OutputLevel::SILENT)
        $silent_option = { :output_level => Test::Unit::UI::Console::OutputLevel::SILENT }
      rescue LoadError
        $silent_option = Test::Unit::UI::SILENT
      end
    end
    Benchmark.realtime { iterations.times { Test::Unit::UI::Console::TestRunner.run(klass, $silent_option) } }
  end
end

desc 'Generate RDoc'
Rake::RDocTask.new('rdoc') do |task|
  task.main = 'README.rdoc'
  task.title = "Mocha #{Mocha::VERSION}"
  task.rdoc_dir = 'doc'
  template = File.expand_path(File.join(File.dirname(__FILE__), "templates", "html_with_google_analytics.rb"))
  if File.exist?(template)
    puts "*** Using RDoc template incorporating Google Analytics"
    task.template = template
  end
  task.rdoc_files.include(
    'README.rdoc',
    'RELEASE.rdoc',
    'COPYING.rdoc',
    'MIT-LICENSE.rdoc',
    'agiledox.txt',
    'lib/mocha/api.rb',
    'lib/mocha/mock.rb',
    'lib/mocha/expectation.rb',
    'lib/mocha/object.rb',
    'lib/mocha/parameter_matchers.rb',
    'lib/mocha/parameter_matchers',
    'lib/mocha/state_machine.rb',
    'lib/mocha/configuration.rb',
    'lib/mocha/stubbing_error.rb'
  )
end

desc "Upload RDoc to RubyForge"
task 'publish_docs' => ['clobber_rdoc', 'rdoc', 'examples', 'agiledox.txt'] do
  require 'rake/contrib/sshpublisher'
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
task 'examples' do
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

task 'release' => 'default' do
  Rake::Task['publish_docs'].invoke
end
