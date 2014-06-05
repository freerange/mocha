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
        alias_method :z, :x
      end
    end
  end

  class A
    extend B
  end

  def test_alias_method_from_module
    test_result = run_as_tests(
      :test_1 => lambda {
        A.stubs(:z)
        assert 1
      },
      :test_2 => lambda {
        A.z
        assert 2
      }
    )

    assert_passed(test_result)
  end

end
