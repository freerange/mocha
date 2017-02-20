# IMPORTANT
#
# This file is meant to be a companion to stubbing_superclass_does_not_affect_subclass_across_test_runs_test.rb
# and is meant to contain exactly the same contents except that the test that declares stubs is removed.
#
require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha'

class StubbingSuperclassDoesNotAffectSubclassAcrossTestRunsWithoutStubsTest < Test::Unit::TestCase

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

  def test_no_stubs_returns_expected_values_without_exceptions
    assert_equal :unstubbed_return, @superclass.method_of_interest
    assert_nothing_raised do
      assert_equal :unstubbed_return, @subclass.method_of_interest
    end
  end

end
