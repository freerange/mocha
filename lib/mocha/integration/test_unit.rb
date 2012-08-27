require 'mocha/options'

require 'mocha/integration/test_unit/ruby_version_185_and_below'
require 'mocha/integration/test_unit/ruby_version_186_and_above'
require 'mocha/integration/test_unit/gem_version_200'
require 'mocha/integration/test_unit/gem_version_201_to_202'
require 'mocha/integration/test_unit/gem_version_203_to_220'
require 'mocha/integration/test_unit/gem_version_230_to_250'
require 'mocha/integration/test_unit/adapter'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.0.0')
end

ruby_version = Gem::Version.new(RUBY_VERSION.dup)

debug_puts "Detected Ruby version: #{ruby_version}"
debug_puts "Detected Test::Unit version: #{test_unit_version}"

test_unit_integration_module = [
  Mocha::Integration::TestUnit::Adapter,
  Mocha::Integration::TestUnit::GemVersion230To250,
  Mocha::Integration::TestUnit::GemVersion203To220,
  Mocha::Integration::TestUnit::GemVersion201To202,
  Mocha::Integration::TestUnit::GemVersion200,
  Mocha::Integration::TestUnit::RubyVersion186AndAbove,
  Mocha::Integration::TestUnit::RubyVersion185AndBelow
].detect { |m| m.applicable_to?(test_unit_version, ruby_version) }

if test_unit_integration_module
  unless Test::Unit::TestCase < test_unit_integration_module
    debug_puts "Applying #{test_unit_integration_module.description}"
    Test::Unit::TestCase.send(:include, test_unit_integration_module)
  end
else
  debug_puts "*** No Mocha integration for Test::Unit version ***"
end

