require 'test/unit'
require 'mocha/integration/test_unit/adapter'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.0.0')
end

test_unit_integration_module = Mocha::Integration::TestUnit::Adapter

unless test_unit_integration_module.applicable_to?(test_unit_version)
  raise "Cannot apply #{test_unit_integration_module.description}."
end

unless Test::Unit::TestCase < test_unit_integration_module
  debug_puts "Applying #{test_unit_integration_module.description}"
  Test::Unit::TestCase.send(:include, test_unit_integration_module)
end
