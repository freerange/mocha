require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'method_definer'
require 'mocha/expectation'
require 'execution_point'

class ExpectationTest < Test::Unit::TestCase
  
  include Mocha
  
  def new_expectation
    Expectation.new(nil, :expected_method)
  end
  
  def test_should_match_calls_to_same_method_with_any_parameters
    assert new_expectation.match?(:expected_method, 1, 2, 3)
  end
  
  def test_should_match_calls_to_same_method_with_exactly_zero_parameters
    expectation = new_expectation.with()
    assert expectation.match?(:expected_method)
  end
  
  def test_should_not_match_calls_to_same_method_with_more_than_zero_parameters
    expectation = new_expectation.with()
    assert !expectation.match?(:expected_method, 1, 2, 3)
  end
  
  def test_should_match_calls_to_same_method_with_expected_parameter_values
    expectation = new_expectation.with(1, 2, 3)
    assert expectation.match?(:expected_method, 1, 2, 3)
  end
  
  def test_should_match_calls_to_same_method_with_parameters_constrained_as_expected
    expectation = new_expectation.with() {|x, y, z| x + y == z}
    assert expectation.match?(:expected_method, 1, 2, 3)
  end
  
  def test_should_not_match_calls_to_different_methods_with_no_parameters
    assert !new_expectation.match?(:unexpected_method)
  end
  
  def test_should_not_match_calls_to_same_method_with_too_few_parameters
    expectation = new_expectation.with(1, 2, 3)
    assert !expectation.match?(:unexpected_method, 1, 2)
  end
  
  def test_should_not_match_calls_to_same_method_with_too_many_parameters
    expectation = new_expectation.with(1, 2)
    assert !expectation.match?(:unexpected_method, 1, 2, 3)
  end
  
  def test_should_not_match_calls_to_same_method_with_unexpected_parameter_values
    expectation = new_expectation.with(1, 2, 3)
    assert !expectation.match?(:unexpected_method, 1, 0, 3)
  end
  
  def test_should_not_match_calls_to_same_method_with_parameters_not_constrained_as_expected
    expectation = new_expectation.with() {|x, y, z| x + y == z}
    assert !expectation.match?(:expected_method, 1, 0, 3)
  end
  
  def test_should_store_provided_backtrace
    backtrace = Object.new
    expectation = Expectation.new(nil, :expected_method, backtrace)
    assert_equal backtrace, expectation.backtrace
  end
  
  def test_should_default_backtrace_to_caller
    execution_point = ExecutionPoint.current; expectation = Expectation.new(nil, :expected_method)
    assert_equal execution_point, ExecutionPoint.new(expectation.backtrace)
  end
  
  def test_should_not_yield
    yielded = false
    new_expectation.invoke() { yielded = true }
    assert_equal false, yielded
  end

  def test_should_yield_no_parameters
    expectation = new_expectation.yields
    yielded_parameters = nil
    expectation.invoke() { |*parameters| yielded_parameters  = parameters }
    assert_equal Array.new, yielded_parameters
  end

  def test_should_yield_with_specified_parameters
    parameters_for_yield = [1, 2, 3]
    expectation = new_expectation.yields(*parameters_for_yield)
    yielded_parameters = nil
    expectation.invoke() { |*parameters| yielded_parameters  = parameters }
    assert_equal parameters_for_yield, yielded_parameters
  end

  def test_should_return_specified_value
    expectation = new_expectation.returns(99)
    assert_equal 99, expectation.invoke
  end
  
  def test_should_return_same_specified_value_multiple_times
    expectation = new_expectation.returns(99)
    assert_equal 99, expectation.invoke
    assert_equal 99, expectation.invoke
  end
  
  def test_should_return_specified_values_on_consecutive_calls
    expectation = new_expectation.returns(99, 100, 101)
    assert_equal 99, expectation.invoke
    assert_equal 100, expectation.invoke
    assert_equal 101, expectation.invoke
  end
  
  def test_should_return_specified_values_on_consecutive_calls_even_if_values_are_modified
    values = [99, 100, 101]
    expectation = new_expectation.returns(*values)
    values.shift
    assert_equal 99, expectation.invoke
    assert_equal 100, expectation.invoke
    assert_equal 101, expectation.invoke
  end
  
  def test_should_return_nil_by_default
    assert_nil new_expectation.invoke
  end
  
  def test_should_return_nil_if_no_value_specified
    expectation = new_expectation.returns()
    assert_nil expectation.invoke
  end
  
  def test_should_return_evaluated_proc
    proc = lambda { 99 }
    expectation = new_expectation.returns(proc)
    assert_equal 99, expectation.invoke
  end
  
  def test_should_return_evaluated_proc_without_using_is_a_method
    proc = lambda { 99 }
    proc.define_instance_accessor(:called)
    proc.called = false
    proc.replace_instance_method(:is_a?) { self.called = true; true}
    expectation = new_expectation.returns(proc)
    expectation.invoke
    assert_equal false, proc.called
  end
  
  def test_should_raise_runtime_exception
    expectation = new_expectation.raises
    assert_raise(RuntimeError) { expectation.invoke }
  end
  
  def test_should_raise_custom_exception
    exception = Class.new(Exception)
    expectation = new_expectation.raises(exception)
    assert_raise(exception) { expectation.invoke }
  end
  
  def test_should_raise_same_instance_of_custom_exception
    exception_klass = Class.new(StandardError)
    expected_exception = exception_klass.new
    expectation = new_expectation.raises(expected_exception)
    actual_exception = assert_raise(exception_klass) { expectation.invoke }
    assert_same expected_exception, actual_exception
  end
  
  def test_should_use_the_default_exception_message
    expectation = new_expectation.raises(Exception)
    exception = assert_raise(Exception) { expectation.invoke }
    assert_equal Exception.new.message, exception.message
  end
  
  def test_should_raise_custom_exception_with_message
    exception_msg = "exception message"
    expectation = new_expectation.raises(Exception, exception_msg)
    exception = assert_raise(Exception) { expectation.invoke }
    assert_equal exception_msg, exception.message
  end
  
  def test_should_not_raise_error_on_verify_if_expected_call_was_made
    expectation = new_expectation
    expectation.invoke
    assert_nothing_raised(ExpectationError) {
      expectation.verify
    }
  end
  
  def test_should_not_raise_error_on_verify_if_expected_call_was_made_at_least_once
    expectation = new_expectation.at_least_once
    3.times {expectation.invoke}
    assert_nothing_raised(ExpectationError) {
      expectation.verify
    }
  end
  
  def test_should_raise_error_on_verify_if_expected_call_was_not_made_at_least_once
    expectation = new_expectation.with(1, 2, 3).at_least_once
    e = assert_raise(ExpectationError) {
      expectation.verify
    }
    assert_match(/expected calls: at least 1, actual calls: 0/i, e.message)
  end
  
  def test_should_not_raise_error_on_verify_if_expected_call_was_made_expected_number_of_times
    expectation = new_expectation.times(2)
    2.times {expectation.invoke}
    assert_nothing_raised(ExpectationError) {
      expectation.verify
    }
  end
  
  def test_should_expect_call_not_to_be_made
    expectation = new_expectation
    expectation.define_instance_accessor(:how_many_times)
    expectation.replace_instance_method(:times) { |how_many_times| self.how_many_times = how_many_times }
    expectation.never
    assert_equal 0, expectation.how_many_times
  end
  
  def test_should_raise_error_on_verify_if_expected_call_was_made_too_few_times
    expectation = new_expectation.times(2)
    1.times {expectation.invoke}
    e = assert_raise(ExpectationError) {
      expectation.verify
    }
    assert_match(/expected calls: 2, actual calls: 1/i, e.message)
  end
  
  def test_should_raise_error_on_verify_if_expected_call_was_made_too_many_times
    expectation = new_expectation.times(2)
    3.times {expectation.invoke}
    assert_raise(ExpectationError) {
      expectation.verify
    }
  end
  
  def test_should_yield_self_to_block
    expectation = new_expectation
    expectation.invoke
    yielded_expectation = nil
    expectation.verify { |x| yielded_expectation = x }
    assert_equal expectation, yielded_expectation
  end
  
  def test_should_yield_to_block_before_raising_exception
    yielded = false
    assert_raise(ExpectationError) {
      new_expectation.verify { |x| yielded = true }
    }
    assert yielded
  end
  
  def test_should_store_backtrace_from_point_where_expectation_was_created
    execution_point = ExecutionPoint.current; expectation = Expectation.new(nil, :expected_method)
    assert_equal execution_point, ExecutionPoint.new(expectation.backtrace)
  end
  
  def test_should_set_backtrace_on_assertion_failed_error_to_point_where_expectation_was_created
    execution_point = ExecutionPoint.current; expectation = Expectation.new(nil, :expected_method)
    error = assert_raise(ExpectationError) {  
      expectation.verify
    }
    assert_equal execution_point, ExecutionPoint.new(error.backtrace)
  end
  
  def test_should_display_expectation_message_in_exception_message
    options = [:a, :b, {:c => 1, :d => 2}]
    expectation = new_expectation.with(*options)
    exception = assert_raise(ExpectationError) {
      expectation.verify
    }
    assert exception.message.include?(expectation.method_signature)
  end
  
  def test_should_combine_method_name_and_pretty_parameters
    arguments = 1, 2, {'a' => true, :b => false}, [1, 2, 3]
    expectation = new_expectation.with(*arguments)
    assert_equal "expected_method(#{PrettyParameters.new(arguments).pretty})", expectation.method_signature
  end
  
  def test_should_not_include_parameters_in_message
    assert_equal "expected_method", new_expectation.method_signature
  end
  
  def test_should_always_verify_successfully
    stub = Stub.new(nil, :expected_method)
    assert stub.verify
    stub.invoke
    assert stub.verify
  end
  
  def test_should_raise_error_with_message_indicating_which_method_was_expected_to_be_called_on_which_mock_object
    mock = Class.new { def mocha_inspect; 'mock'; end }.new
    expectation = Expectation.new(mock, :expected_method)
    e = assert_raise(ExpectationError) { expectation.verify }
    assert_match "mock.expected_method", e.message
  end
  
end

class ExpectationSimilarExpectationsTest < Test::Unit::TestCase
  
  include Mocha
  
  def new_expectation
    Expectation.new(nil, :expected_method)
  end
    
  def test_should_find_expectations_to_the_same_method
    expectation = new_expectation.with(1)
    mock = Object.new
    mock.define_instance_method(:expectations) { [expectation] }
    failed_expectation = MissingExpectation.new(mock, :expected_method).with(2)
    assert_equal [expectation], failed_expectation.similar_expectations
  end
  
  def test_should_report_similar_expectations
    mock = Object.new
    expectation_1 = new_expectation.with(1)
    expectation_2 = new_expectation.with(2)
    mock = Object.new
    mock.define_instance_method(:expectations) { [expectation_1, expectation_2] }
    missing_expectation = MissingExpectation.new(mock, :expected_method).with(3)
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    assert_equal "#{mock.mocha_inspect}.expected_method(3) - expected calls: 0, actual calls: 1\nSimilar expectations:\nexpected_method(1)\nexpected_method(2)", exception.message
  end
  
  def test_should_ignore_expectations_to_different_methods
    expectation = new_expectation.with(1)
    mock = Object.new
    mock.define_instance_method(:expectations) { [expectation] }
    failed_expectation = MissingExpectation.new(mock, :other_method).with(1)
    assert failed_expectation.similar_expectations.empty?
  end
  
  def test_should_not_report_similar_expectations
    expectation = new_expectation.with(1)
    mock = Object.new
    mock.define_instance_method(:expectations) { [expectation] }
    mock.define_instance_method(:mocha_inspect) { 'mocha_inspect' }
    missing_expectation = MissingExpectation.new(mock, :unexpected_method).with(1)
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    assert_equal "mocha_inspect.unexpected_method(1) - expected calls: 0, actual calls: 1", exception.message
  end
  
  def test_should_exclude_mocha_locations_from_backtrace
    mocha_lib = "/username/workspace/mocha_wibble/lib/"
    backtrace = [ mocha_lib + 'exclude/me/1', mocha_lib + 'exclude/me/2', '/keep/me', mocha_lib + 'exclude/me/3']
    expectation = Expectation.new(nil, :expected_method, backtrace)
    expectation.define_instance_method(:mocha_lib_directory) { mocha_lib }
    assert_equal ['/keep/me'], expectation.filtered_backtrace
  end
  
  def test_should_determine_path_for_mocha_lib_directory
    expectation = new_expectation()
    assert_match Regexp.new("/lib/$"), expectation.mocha_lib_directory
  end
  
end