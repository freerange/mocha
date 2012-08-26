require 'mocha/api'
require 'mocha/options'

require 'mocha/integration/test_unit/ruby_version_185_and_below'
require 'mocha/integration/test_unit/ruby_version_186_and_above'

require 'mocha/integration/test_unit/gem_version_200'
require 'mocha/integration/test_unit/gem_version_201_to_202'
require 'mocha/integration/test_unit/gem_version_203_to_220'
require 'mocha/integration/test_unit/gem_version_230_to_250'

require 'mocha/adapters/test_unit'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.x')
end

if $mocha_options['debug']
  $stderr.puts "Detected Ruby version: #{RUBY_VERSION}"
  $stderr.puts "Detected Test::Unit version: #{test_unit_version}"
end

test_unit_integration_module = if (test_unit_version == Gem::Version.new('1.x')) || (test_unit_version == Gem::Version.new('1.2.3'))
  if RUBY_VERSION < '1.8.6'
    Mocha::Integration::TestUnit::RubyVersion185AndBelow
  else
    Mocha::Integration::TestUnit::RubyVersion186AndAbove
  end
elsif Gem::Requirement.new('2.0.0').satisfied_by?(test_unit_version)
  Mocha::Integration::TestUnit::GemVersion200
elsif Gem::Requirement.new('>= 2.0.1', '<= 2.0.2').satisfied_by?(test_unit_version)
  Mocha::Integration::TestUnit::GemVersion201To202
elsif Gem::Requirement.new('>= 2.0.3', '<= 2.2.0').satisfied_by?(test_unit_version)
  Mocha::Integration::TestUnit::GemVersion203To220
elsif Gem::Requirement.new('>= 2.3.0', '<= 2.5.0').satisfied_by?(test_unit_version)
  Mocha::Integration::TestUnit::GemVersion230To250
elsif Gem::Requirement.new('>= 2.5.1').satisfied_by?(test_unit_version)
  Mocha::Adapters::TestUnit
else
  $stderr.puts "*** No Mocha monkey-patch for Test::Unit version ***" if $mocha_options['debug']
  nil
end

if test_unit_integration_module && !Test::Unit::TestCase.ancestors.include?(test_unit_integration_module)
  $stderr.puts "Applying #{test_unit_integration_module.description}" if $mocha_options['debug']
  Test::Unit::TestCase.send(:include, test_unit_integration_module)
end
