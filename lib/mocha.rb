require 'mocha_standalone'
require 'mocha/configuration'

# todo - MiniTest is a gem in Ruby 1.8, but part of stdlib in Ruby 1.9

require 'mocha/mini_test_adapter'
require 'rubygems'
require 'minitest/unit'

module MiniTest
  class Unit
    class TestCase
      include Mocha::Standalone
      include Mocha::MiniTestCaseAdapter
    end
  end
end

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
