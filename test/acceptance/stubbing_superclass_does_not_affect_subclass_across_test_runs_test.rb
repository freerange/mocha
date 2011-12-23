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

  def test_stubbing_superclass
    @superclass.stubs(:method_of_interest).returns(:stubbed_return)
    assert_equal :stubbed_return, @superclass.method_of_interest
    assert_equal :stubbed_return, @subclass.method_of_interest
  end

  # IMPORTANT: this test is meant to be run chronologically after the above test.
  # TODO: I'm not 100% sure how to enforce test ordering.
  def test_no_stubs_returns_expected_values_without_exceptions
    assert_equal :unstubbed_return, @superclass.method_of_interest
    assert_nothing_raised do
      assert_equal :unstubbed_return, @subclass.method_of_interest
    end
  end

end
