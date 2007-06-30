require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/missing_expectation'
require 'method_definer'

class MissingExpectationsTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_find_similar_expectations_on_mock
    mock = Object.new
    missing_expectation = MissingExpectation.new(mock, :expected_method)
    method_names = []
    similar_expectations = [Expectation.new(mock, :expected_method)]
    mock.define_instance_method(:similar_expectations) { |method_name| method_names << method_name; similar_expectations }
    assert_equal similar_expectations, missing_expectation.similar_expectations
    assert_equal [:expected_method], method_names
  end
  
  def test_should_report_similar_expectations
    expectation_1 = Expectation.new(nil, :expected_method).with(1)
    expectation_2 = Expectation.new(nil, :expected_method).with(2)

    mock = Object.new
    mock.define_instance_method(:similar_expectations) { [expectation_1, expectation_2] }
    mock.define_instance_method(:mocha_inspect) { 'mocha_inspect' }

    missing_expectation = MissingExpectation.new(mock, :expected_method).with(3)
    
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    assert_equal "mocha_inspect.expected_method(3) - expected calls: 0, actual calls: 1\nSimilar expectations:\nexpected_method(1)\nexpected_method(2)", exception.message
  end
  
  def test_should_not_report_similar_expectations_if_there_are_none
    mock = Object.new
    mock.define_instance_method(:similar_expectations) { [] }
    mock.define_instance_method(:mocha_inspect) { 'mocha_inspect' }

    missing_expectation = MissingExpectation.new(mock, :unexpected_method).with(1)
    
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    assert_equal "mocha_inspect.unexpected_method(1) - expected calls: 0, actual calls: 1", exception.message
  end
  
end