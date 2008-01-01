require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/cardinality'

class CardinalityTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_allow_invocations_if_invocation_count_has_not_yet_reached_maximum
    cardinality = Cardinality.new(2, 3)
    assert cardinality.invocations_allowed?(0)
    assert cardinality.invocations_allowed?(1)
    assert cardinality.invocations_allowed?(2)
    assert !cardinality.invocations_allowed?(3)
  end
  
  def test_should_be_satisfied_if_invocations_so_far_have_reached_required_threshold
    cardinality = Cardinality.new(2, 3)
    assert !cardinality.satisfied?(0)
    assert !cardinality.satisfied?(1)
    assert cardinality.satisfied?(2)
    assert cardinality.satisfied?(3)
  end
  
  def test_should_describe_cardinality
    assert_equal '2', Cardinality.exactly(2).mocha_inspect
    assert_equal 'at least 3', Cardinality.at_least(3).mocha_inspect
    assert_equal 'at most 2', Cardinality.at_most(2).mocha_inspect
    assert_equal '4', Cardinality.times(4).mocha_inspect
    assert_equal '2..4', Cardinality.times(2..4).mocha_inspect
  end
  
end