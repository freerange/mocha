require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/missing_expectation'
require 'method_definer'

class MissingExpectationsTest < Test::Unit::TestCase
  
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
  
end