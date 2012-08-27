require 'mocha/options'

require 'mocha/integration/mini_test/version_13'
require 'mocha/integration/mini_test/version_140'
require 'mocha/integration/mini_test/version_141'
require 'mocha/integration/mini_test/version_142_to_172'
require 'mocha/integration/mini_test/version_200'
require 'mocha/integration/mini_test/version_201_to_222'
require 'mocha/integration/mini_test/version_230_to_2101'
require 'mocha/integration/mini_test/version_2110_to_2111'
require 'mocha/integration/mini_test/version_2112_to_320'

require 'mocha/adapters/mini_test'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

$stderr.puts "Detected MiniTest version: #{mini_test_version}" if $mocha_options['debug']

minitest_integration_module = [
  Mocha::Adapters::MiniTest,
  Mocha::Integration::MiniTest::Version2112To320,
  Mocha::Integration::MiniTest::Version2110To2111,
  Mocha::Integration::MiniTest::Version230To2101,
  Mocha::Integration::MiniTest::Version201To222,
  Mocha::Integration::MiniTest::Version200,
  Mocha::Integration::MiniTest::Version142To172,
  Mocha::Integration::MiniTest::Version141,
  Mocha::Integration::MiniTest::Version140,
  Mocha::Integration::MiniTest::Version13
].detect { |m| m.applicable_to?(mini_test_version) }

if minitest_integration_module
  unless MiniTest::Unit::TestCase.ancestors.include?(minitest_integration_module)
    $stderr.puts "Applying #{minitest_integration_module.description}" if $mocha_options['debug']
    MiniTest::Unit::TestCase.send(:include, minitest_integration_module)
  end
else
  $stderr.puts "*** No Mocha integration for MiniTest version ***" if $mocha_options['debug']
end
