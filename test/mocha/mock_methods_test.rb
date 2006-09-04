require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mock_methods'
require 'set'

class MockMethodsTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_create_and_add_expectations
    mock = Object.new
    mock.extend(MockMethods)
    
    expectation1 = mock.expects(:method1)
    expectation2 = mock.expects(:method2)
    
    assert_equal [expectation1, expectation2].to_set, mock.expectations.to_set
  end
  
  def test_should_pass_backtrace_into_expectation
    mock = Object.new
    mock.extend(MockMethods)
    backtrace = Object.new
    expectation = mock.expects(:method1, backtrace)
    assert_equal backtrace, expectation.backtrace
  end
  
  def test_should_pass_backtrace_into_stub
    mock = Object.new
    mock.extend(MockMethods)
    backtrace = Object.new
    stub = mock.stubs(:method1, backtrace)
    assert_equal backtrace, stub.backtrace
  end
  
  def test_should_create_and_add_stubs
    mock = Object.new
    mock.extend(MockMethods)
    
    stub1 = mock.stubs(:method1)
    stub2 = mock.stubs(:method2)
    
    assert_equal [stub1, stub2].to_set, mock.expectations.to_set
  end
  
  def test_should_find_matching_expectation
    mock = Object.new
    mock.extend(MockMethods)

    expectation1 = mock.expects(:my_method).with(:argument1, :argument2)
    expectation2 = mock.expects(:my_method).with(:argument3, :argument4)
    
    assert_equal expectation2, mock.matching_expectation(:my_method, :argument3, :argument4)
  end
  
  def test_should_invoke_expectation_and_return_result
    mock = Object.new
    mock.extend(MockMethods)
    mock.expects(:my_method).returns(:result)
    
    result = mock.my_method
    
    assert_equal :result, result
  end
  
  def test_should_not_raise_error_if_stubbing_everything
    mock = Class.new { def initialize; @stub_everything = true; end }.new
    mock.extend(MockMethods)
    
    result = nil
    assert_nothing_raised(Test::Unit::AssertionFailedError) do
      result = mock.unexpected_method
    end
    assert_nil result
  end
  
  def test_should_raise_no_method_error
    mock = Object.new
    mock.extend(MockMethods)
    assert_raise(NoMethodError) do
      mock.super_method_missing(nil)
    end
  end
  
  def test_should_raise_assertion_error_for_unexpected_method_call
    mock = Object.new
    mock.extend(MockMethods)
    error = assert_raise(Test::Unit::AssertionFailedError) do
      mock.unexpected_method_called(:my_method, :argument1, :argument2)
    end
    assert_match /my_method/, error.message
    assert_match /argument1/, error.message
    assert_match /argument2/, error.message
  end
  
  def test_should_indicate_unexpected_method_called
    mock = Object.new
    mock.extend(MockMethods)
    class << mock
      attr_accessor :symbol, :arguments
      def unexpected_method_called(symbol, *arguments)
        self.symbol, self.arguments = symbol, arguments
      end
    end
    mock.my_method(:argument1, :argument2)

    assert_equal :my_method, mock.symbol
    assert_equal [:argument1, :argument2], mock.arguments
  end
  
  def test_should_call_method_missing_for_parent
    mock = Object.new
    mock.extend(MockMethods)
    class << mock
      attr_accessor :symbol, :arguments
      def super_method_missing(symbol, *arguments, &block)
        self.symbol, self.arguments = symbol, arguments
      end
    end
    
    mock.my_method(:argument1, :argument2)
    
    assert_equal :my_method, mock.symbol
    assert_equal [:argument1, :argument2], mock.arguments
  end
  
  def test_should_verify_that_all_expectations_have_been_fulfilled
    mock = Object.new
    mock.extend(MockMethods)
    mock.expects(:method1)
    mock.expects(:method2)
    mock.method1
    assert_raise(Test::Unit::AssertionFailedError) do
      mock.verify
    end
  end
  
  def test_should_report_possible_expectations
    mock = Object.new.extend(MockMethods)
    mock.expects(:meth).with(1)
    exception = assert_raise(Test::Unit::AssertionFailedError) { mock.meth(2) }
    assert_equal "Unexpected message :meth(2) sent to #{mock.mocha_inspect}\nSimilar expectations :meth(1)", exception.message
  end
  
  def test_should_pass_block_through_to_expectations_verify_method
    mock = Object.new
    mock.extend(MockMethods)
    expected_expectation = mock.expects(:method1)
    mock.method1
    expectations = []
    mock.verify() { |expectation| expectations << expectation }
    assert_equal [expected_expectation], expectations
  end
  
  def test_should_yield_supplied_parameters_to_block
    mock = Object.new
    mock.extend(MockMethods)
    parameters_for_yield = [1, 2, 3]
    mock.expects(:method1).yields(*parameters_for_yield)
    yielded_parameters = nil
    mock.method1() { |*parameters| yielded_parameters = parameters }
    assert_equal parameters_for_yield, yielded_parameters
  end
  
  def test_should_respond_to_expected_method
    mock = Object.new
    mock.extend(MockMethods)
    mock.expects(:method1)
    assert_equal true, mock.respond_to?(:method1)
  end
  
  def test_should_not_respond_to_unexpected_method
    mock = Object.new
    mock.extend(MockMethods)
    assert_equal false, mock.respond_to?(:method1)
  end
  
end