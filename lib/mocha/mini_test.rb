require 'minitest/unit'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

unless Gem::Requirement.new('>= 3.3.0').satisfied_by?(mini_test_version)
  raise "Mocha::Adapters::MiniTest requires MiniTest version 3.3.0 or higher."
end

require 'mocha/adapters/mini_test'

class MiniTest::Unit::TestCase
  include Mocha::Adapters::MiniTest
end
