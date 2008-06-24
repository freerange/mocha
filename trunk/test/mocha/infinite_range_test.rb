require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/infinite_range'

class InfiniteRangeTest < Test::Unit::TestCase
  
  def test_should_include_values_at_or_above_minimum
    range = Range.at_least(10)
    assert(range === 10)
    assert(range === 11)
    assert(range === 1000000)
  end
  
  def test_should_not_include_values_below_minimum
    range = Range.at_least(10)
    assert_false(range === 0)
    assert_false(range === 9)
    assert_false(range === -11)
  end
  
  def test_should_be_human_readable_description_for_at_least
    assert_equal "at least 10", Range.at_least(10).to_s
  end
  
  def test_should_include_values_at_or_below_maximum
    range = Range.at_most(10)
    assert(range === 10)
    assert(range === 0)
    assert(range === -1000000)
  end
  
  def test_should_not_include_values_above_maximum
    range = Range.at_most(10)
    assert_false(range === 11)
    assert_false(range === 1000000)
  end
  
  def test_should_be_human_readable_description_for_at_most
    assert_equal "at most 10", Range.at_most(10).to_s
  end
  
  def test_should_not_break_original_description
    assert_equal "1..10", (1..10).to_s
    assert_equal "1...10", (1...10).to_s
  end
  
  def assert_false(condition)
    assert(!condition)
  end
  
end