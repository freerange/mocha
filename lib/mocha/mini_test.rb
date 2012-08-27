require 'minitest/unit'
require 'mocha/integration/mini_test/adapter'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

unless Gem::Requirement.new('>= 3.3.0').satisfied_by?(mini_test_version)
  raise "Mocha::Integration::MiniTest::Adapter requires MiniTest version 3.3.0 or higher."
end

class MiniTest::Unit::TestCase
  include Mocha::Integration::MiniTest::Adapter
end
