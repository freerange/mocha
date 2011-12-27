require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha'

class StubbingSuperclassDoesNotAffectSubclassAcrossTestRunsTest < Test::Unit::TestCase

  include AcceptanceTest

  def setup
    @superclass = Class.new
    @superclass.class_eval do
      class << self
        def method_of_interest
          :unstubbed_return
        end
      end
    end
    @subclass = Class.new(@superclass)
  end

  def test_a_no_stubs_returns_expected_values_without_exceptions_before_test_that_stubs_superclass
    puts 'before'
    assert_nothing_raised do
      assert_equal :unstubbed_return, @superclass.method_of_interest
      assert_equal :unstubbed_return, @subclass.method_of_interest
    end
  end

  def test_b_stubbing_superclass
    puts 'stubbing'
    @superclass.stubs(:method_of_interest).returns(:stubbed_return)
    @subclass.stubs(:method_of_interest).returns(:stubbed_return)
    assert_equal :stubbed_return, @superclass.method_of_interest
    assert_equal :stubbed_return, @subclass.method_of_interest
  end

  def test_c_no_stubs_returns_expected_values_without_exceptions_after_test_that_stubs_superclass
    puts 'after'
    assert_nothing_raised do
      assert_equal :unstubbed_return, @superclass.method_of_interest
      assert_equal :unstubbed_return, @subclass.method_of_interest
    end
  end

end
