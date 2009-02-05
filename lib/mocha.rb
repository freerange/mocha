require 'mocha_standalone'
require 'mocha/configuration'

begin
  require 'minitest/unit'
rescue LoadError
  # MiniTest not available
end

if defined?(MiniTest)
  require 'mocha/mini_test_adapter'

  module MiniTest
    class Unit
      class TestCase
        include Mocha::Standalone
        include Mocha::MiniTestCaseAdapter
      end
    end
  end
end

require 'test/unit/testcase'

require 'mocha/test_unit_gem_version_200_monkey_patch'
require 'mocha/test_unit_gem_version_201_and_above_monkey_patch'
require 'mocha/ruby_version_185_and_below_monkey_patch'
require 'mocha/ruby_version_186_and_above_monkey_patch'

unless Test::Unit::TestCase.ancestors.include?(Mocha::Standalone)
  module Test
    module Unit
      class TestCase
        
        include Mocha::Standalone
        
        alias_method :run_before_mocha, :run
        remove_method :run
        
        test_unit_version = begin
          require 'test/unit/version'
          Test::Unit::VERSION
        rescue LoadError
          '1.x'
        end

        if test_unit_version == '2.0.0'
          include Mocha::TestUnitGem::Version200::MonkeyPatch
        elsif test_unit_version >= '2.0.1'
          include Mocha::TestUnitGem::Version201AndAbove::MonkeyPatch
        elsif RUBY_VERSION < '1.8.6'
          include Mocha::Ruby::Version185AndBelow::MonkeyPatch
        else
          include Mocha::Ruby::Version186AndAbove::MonkeyPatch
        end
        
      end
    end
  end
end
