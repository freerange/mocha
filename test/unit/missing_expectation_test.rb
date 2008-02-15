require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/missing_expectation'
require 'mocha/mock'
require 'mocha/cardinality'

class MissingExpectationTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_report_similar_expectations
    mock = Mock.new('mock')
    expectation_1 = mock.expects(:method_one).with(1)
    expectation_2 = mock.expects(:method_one).with(1, 1)
    expectation_3 = mock.expects(:method_two).with(2)

    missing_expectation = MissingExpectation.new(mock, :method_one)
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    
    expected_message = [
      "unexpected invocation: 'mock'.method_one(any_parameters)",
      "Similar expectations:",
      "#{expectation_1.mocha_inspect}",
      "#{expectation_2.mocha_inspect}"
    ].join("\n")
    
    assert_equal expected_message, exception.message
  end
  
  def test_should_not_report_similar_expectations_if_there_are_none
    mock = Mock.new('mock')
    mock.expects(:method_two).with(2)
    mock.expects(:method_two).with(2, 2)

    missing_expectation = MissingExpectation.new(mock, :method_one)
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    
    expected_message = "unexpected invocation: 'mock'.method_one(any_parameters)"
    
    assert_equal expected_message, exception.message
  end
  
end