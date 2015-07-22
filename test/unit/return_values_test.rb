require File.expand_path('../../test_helper', __FILE__)

require 'mocha/return_values'

class ReturnValuesTest < Mocha::TestCase

  include Mocha

  def test_should_return_nil
    values = ReturnValues.new
    assert_nil values.next
  end

  def test_should_keep_returning_nil
    values = ReturnValues.new
    values.next
    assert_nil values.next
    assert_nil values.next
  end

  def test_should_return_evaluated_single_return_value
    values = ReturnValues.new(SingleReturnValue.new('value'))
    assert_equal 'value', values.next
  end

  def test_should_keep_returning_evaluated_single_return_value
    values = ReturnValues.new(SingleReturnValue.new('value'))
    values.next
    assert_equal 'value', values.next
    assert_equal 'value', values.next
  end

  def test_should_return_consecutive_evaluated_single_return_values
    values = ReturnValues.new(SingleReturnValue.new('value_1'), SingleReturnValue.new('value_2'))
    assert_equal 'value_1', values.next
    assert_equal 'value_2', values.next
  end

  def test_should_keep_returning_last_of_consecutive_evaluated_single_return_values
    values = ReturnValues.new(SingleReturnValue.new('value_1'), SingleReturnValue.new('value_2'))
    values.next
    values.next
    assert_equal 'value_2', values.next
    assert_equal 'value_2', values.next
  end

  def test_should_evaluate_return_block
    method = Proc.new { |arg1, arg2| arg1 + arg2 }
    values = ReturnValues.new(SingleReturnValue.new(method))
    assert_equal 3, values.next(1, 2)
    assert_equal 7, values.next(3, 4)
  end

  def test_should_build_single_return_values_for_each_values
    values = ReturnValues.build('value_1', 'value_2', 'value_3').values
    assert_equal 'value_1', values[0].evaluate
    assert_equal 'value_2', values[1].evaluate
    assert_equal 'value_3', values[2].evaluate
  end

  def test_should_combine_two_sets_of_return_values
    values_1 = ReturnValues.build('value_1')
    values_2 = ReturnValues.build('value_2a', 'value_2b')
    values = (values_1 + values_2).values
    assert_equal 'value_1', values[0].evaluate
    assert_equal 'value_2a', values[1].evaluate
    assert_equal 'value_2b', values[2].evaluate
  end

  def test_should_combine_return_values_with_block
    values_1 = ReturnValues.build('value_1a', 'value_1b')
    values_2 = ReturnValues.build() { 'value_2' }
    values = (values_1 + values_2).values
    assert_equal 'value_1a', values[0].evaluate
    assert_equal 'value_1b', values[1].evaluate
    assert_equal 'value_2', values[2].evaluate
  end

end
