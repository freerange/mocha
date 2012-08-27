require 'minitest/unit'
require 'mocha/options'
require 'mocha/integration/mini_test/adapter'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

minitest_integration_module = Mocha::Integration::MiniTest::Adapter

unless minitest_integration_module.applicable_to?(mini_test_version)
  raise "Cannot apply #{minitest_integration_module.description}."
end

unless MiniTest::Unit::TestCase < minitest_integration_module
  debug_puts "Applying #{minitest_integration_module.description}"
  MiniTest::Unit::TestCase.send(:include, minitest_integration_module)
end
