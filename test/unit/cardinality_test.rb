# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/cardinality'
require 'mocha/invocation'
require 'mocha/return_values'
require 'mocha/yield_parameters'

class CardinalityTest < Mocha::TestCase
  include Mocha

  def new_invocation
    Invocation.new(:irrelevant, :irrelevant)
  end

  def test_should_allow_invocations_if_invocation_count_has_not_yet_reached_maximum
    cardinality = Cardinality.new.range(2, 3)
    assert cardinality.invocations_allowed?
    cardinality << new_invocation
    assert cardinality.invocations_allowed?
    cardinality << new_invocation
    assert cardinality.invocations_allowed?
    cardinality << new_invocation
    assert !cardinality.invocations_allowed?
  end

  def test_should_never_allow_invocations
    cardinality = Cardinality.new.range(0, 0)
    assert cardinality.invocations_never_allowed?
    cardinality << new_invocation
    assert cardinality.invocations_never_allowed?
  end

  def test_should_be_satisfied_if_invocations_so_far_have_reached_required_threshold
    cardinality = Cardinality.new.range(2, 3)
    assert !cardinality.satisfied?
    cardinality << new_invocation
    assert !cardinality.satisfied?
    cardinality << new_invocation
    assert cardinality.satisfied?
    cardinality << new_invocation
    assert cardinality.satisfied?
  end

  def test_should_describe_cardinality_defined_using_at_least
    assert_equal 'allowed any number of times', Cardinality.new.range(0).anticipated_times
    assert_equal 'expected at least once', Cardinality.new.range(1).anticipated_times
    assert_equal 'expected at least twice', Cardinality.new.range(2).anticipated_times
    assert_equal 'expected at least 3 times', Cardinality.new.range(3).anticipated_times
  end

  def test_should_describe_cardinality_defined_using_at_most
    assert_equal 'expected at most once', Cardinality.new.range(0, 1).anticipated_times
    assert_equal 'expected at most twice', Cardinality.new.range(0, 2).anticipated_times
    assert_equal 'expected at most 3 times', Cardinality.new.range(0, 3).anticipated_times
  end

  def test_should_describe_cardinality_defined_using_exactly
    assert_equal 'expected never', Cardinality.new.range(0, 0).anticipated_times
    assert_equal 'expected exactly once', Cardinality.new.range(1, 1).anticipated_times
    assert_equal 'expected exactly twice', Cardinality.new.range(2, 2).anticipated_times
    assert_equal 'expected exactly 3 times', Cardinality.new.range(3, 3).anticipated_times
  end

  def test_should_describe_cardinality_defined_using_times_with_range
    assert_equal 'expected between 2 and 4 times', Cardinality.new.range(2, 4).anticipated_times
    assert_equal 'expected between 1 and 3 times', Cardinality.new.range(1, 3).anticipated_times
  end

  def test_should_need_verifying
    assert Cardinality.new.range(2, 2).needs_verifying?
    assert Cardinality.new.range(3).needs_verifying?
    assert Cardinality.new.range(0, 2).needs_verifying?
    assert Cardinality.new.range(4).needs_verifying?
    assert Cardinality.new.range(2, 4).needs_verifying?
  end

  def test_should_not_need_verifying
    assert_equal false, Cardinality.new.range(0).needs_verifying?
  end
end
