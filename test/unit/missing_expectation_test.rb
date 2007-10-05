require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/missing_expectation'
require 'method_definer'

class MissingExpectationTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_report_similar_expectations
    method_signature = Object.new
    method_signature.define_instance_method(:to_s) { 'missing_expectation' }
    similar_expectations = [ "similar_expectation_1", "similar_expectation_2" ]
    method_signature.define_instance_method(:similar_method_signatures) { similar_expectations }
    missing_expectation = MissingExpectation.new(nil, nil)
    missing_expectation.define_instance_method(:method_signature) { method_signature }
    
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    
    expected_message = [
      "missing_expectation - expected calls: 0, actual calls: 1",
      "Similar expectations:",
      "similar_expectation_1",
      "similar_expectation_2"
    ].join("\n")
    
    assert_equal expected_message, exception.message
  end
  
  def test_should_not_report_similar_expectations_if_there_are_none
    method_signature = Object.new
    method_signature.define_instance_method(:to_s) { 'missing_expectation' }
    method_signature.define_instance_method(:similar_method_signatures) { [] }
    missing_expectation = MissingExpectation.new(nil, nil)
    missing_expectation.define_instance_method(:method_signature) { method_signature }
    
    exception = assert_raise(ExpectationError) { missing_expectation.verify }
    
    expected_message = "missing_expectation - expected calls: 0, actual calls: 1"
    
    assert_equal expected_message, exception.message
  end
  
end