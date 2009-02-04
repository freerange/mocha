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

require 'mocha/test_case_adapter'
require 'test/unit/testcase'

unless Test::Unit::TestCase.ancestors.include?(Mocha::Standalone)
  module Test
    module Unit
      class TestCase
        include Mocha::Standalone
        include Mocha::TestCaseAdapter
      end
    end
  end
end
