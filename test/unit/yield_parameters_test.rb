require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/yield_parameters'

class YieldParametersTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_return_nil_by_default
    yield_parameters = YieldParameters.new
    assert_nil yield_parameters.next
  end
  
  def test_should_keep_returning_nil
    yield_parameters = YieldParameters.new
    yield_parameters.next
    assert_nil yield_parameters.next
    assert_nil yield_parameters.next
  end
  
  def test_should_return_single_parameter_group
    yield_parameters = YieldParameters.new
    yield_parameters.add(1, 2, 3)
    assert_equal [1, 2, 3], yield_parameters.next
  end
  
  def test_should_return_single_parameter_group
    yield_parameters = YieldParameters.new
    yield_parameters.add(1, 2, 3)
    assert_equal [1, 2, 3], yield_parameters.next
  end
  
  def test_should_keep_returning_single_parameter_group
    yield_parameters = YieldParameters.new
    yield_parameters.add(1, 2, 3)
    yield_parameters.next
    assert_equal [1, 2, 3], yield_parameters.next
    assert_equal [1, 2, 3], yield_parameters.next
  end
  
  def test_should_return_consecutive_parameter_groups
    yield_parameters = YieldParameters.new
    yield_parameters.add(1, 2, 3)
    yield_parameters.add(4, 5)
    assert_equal [1, 2, 3], yield_parameters.next
    assert_equal [4, 5], yield_parameters.next
  end
  
  def test_should_keep_returning_last_of_consecutive_parameter_groups
    yield_parameters = YieldParameters.new
    yield_parameters.add(1, 2, 3)
    yield_parameters.add(4, 5)
    yield_parameters.next
    yield_parameters.next
    assert_equal [4, 5], yield_parameters.next
    assert_equal [4, 5], yield_parameters.next
  end
  
end