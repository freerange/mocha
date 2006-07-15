require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mock'

class MockTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_include_mocha_methods
   assert Mock.included_modules.include?(MockMethods)
  end

  def test_should_set_single_expectation
   mock = Mock.new
   mock.expects(:method1).returns(1)
   assert_nothing_raised(Test::Unit::AssertionFailedError) do
     assert_equal 1, mock.method1
   end
  end 

  def test_should_set_multiple_expectations_in_constructor
   mock = Mock.new(:method1 => 1, :method2 => 2)
   assert_nothing_raised(Test::Unit::AssertionFailedError) do
     assert_equal 1, mock.method1
     assert_equal 2, mock.method2
   end
  end 

  def test_should_claim_to_respond_to_any_method
   mock = Mock.new
   always_responds = mock.always_responds
   assert always_responds.respond_to?(:gobble_de_gook)
  end

  def test_should_raise_exception_if_attempting_to_mock_undefined_method
   mocked = Class.new
   mock = Mock.new(mocked.new)
   assert_raise(Test::Unit::AssertionFailedError) do
     mock.expects(:method1)
   end
  end

  def test_should_not_raise_exception_if_attempting_to_mock_defined_method
   mocked = Class.new { def method1; end }
   mock = Mock.new(mocked.new)
   assert_nothing_raised(Test::Unit::AssertionFailedError) do
     mock.expects(:method1)
   end
  end

  def test_should_not_raise_exception_if_attempting_to_mock_method_when_no_class_specified
   mock = Mock.new
   assert_nothing_raised(Test::Unit::AssertionFailedError) do
     mock.expects(:method1)
   end
  end

  def test_should_build_and_store_expectations
   mock = Mock.new
   expectation = mock.expects(:method1)
   assert_not_nil expectation
   assert_equal [expectation], mock.expectations
  end
   
end