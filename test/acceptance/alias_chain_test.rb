require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class AliasChainTest < Mocha::TestCase
  include AcceptanceTest
  i_suck_and_my_tests_are_order_dependent!

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

  def test_a
    A.stubs(:y)
    assert 1
  end

  def test_b
    A.y
    assert 2
  end

end
