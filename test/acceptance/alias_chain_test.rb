require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class AliasChainTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  module B
    def x
    end

    def self.extended(base)
      class << base
        alias_method :y, :x
      end
    end
  end

  class A
    extend B
  end

  def test_alias_method_from_module
    test_result = run_as_tests(
      :test_2 => lambda {
        A.y
        assert 2
      },
      :test_1 => lambda {
        A.stubs(:y)
        assert 1
      }
    )

    assert_passed(test_result)
  end

end
