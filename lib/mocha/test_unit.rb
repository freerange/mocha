require 'test/unit'
require 'mocha/integration/test_unit/adapter'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.0.0')
end

unless Gem::Requirement.new('>= 2.5.1').satisfied_by?(test_unit_version)
  raise "Mocha::Integration::TestUnit::Adapter requires Test::Unit version 2.5.1 or higher."
end

class Test::Unit::TestCase
  include Mocha::Integration::TestUnit::Adapter
end
