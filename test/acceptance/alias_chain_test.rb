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
    def b
    end
  end

  module C
    def c
    end
  end

  class A
    extend B
    class << self
      alias_method :aliased_b, :b
    end

    include C
    alias_method :aliased_c, :c
  end

  def test_alias_method_from_module_on_class
    test_result = run_as_tests(
      :test_1 => lambda {
        A.stubs(:aliased_b)
        assert 1
      },
      :test_2 => lambda {
        A.aliased_b
        assert 2
      }
    )

    assert_passed(test_result)
  end

  def test_alias_method_from_module_on_instance
    instance = A.new
    test_result = run_as_tests(
      :test_1 => lambda {
        instance.stubs(:aliased_c)
        assert 1
      },
      :test_2 => lambda {
        instance.aliased_c
        assert 2
      }
    )

    assert_passed(test_result)
  end

end
