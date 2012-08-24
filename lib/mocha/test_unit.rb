require 'mocha/adapters/test_unit'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.x')
end

unless Gem::Requirement.new('>= 2.5.1').satisfied_by?(test_unit_version)
  raise "Mocha::Adapters::TestUnit requires Test::Unit version 2.5.1 or higher."
end

class Test::Unit::TestCase
  include Mocha::Adapters::TestUnit
end
