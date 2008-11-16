require 'mocha_standalone'
require 'mocha/configuration'

if defined? MiniTest
  require 'mocha/mini_test_adapter'
  module MiniTest
    class Unit
      class TestCase
        include Mocha::Standalone
        include Mocha::MiniTestCaseAdapter
      end
    end
  end

else
  require 'mocha/test_case_adapter'
  require 'test/unit/testcase'

  module Test
    module Unit
      class TestCase
        include Mocha::Standalone
        include Mocha::TestCaseAdapter
      end
    end
  end
end