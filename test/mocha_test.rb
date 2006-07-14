require 'test_helper'
require 'mocha/mocha'

class MochaTest < Test::Unit::TestCase
  
   def test_should_include_mocha_methods
     assert Mocha.included_modules.include?(MochaMethods)
   end
   
   def test_should_set_single_expectation
     mock = Mocha.new
     mock.expects(:method1).returns(1)
     assert_nothing_raised(Test::Unit::AssertionFailedError) do
       assert_equal 1, mock.method1
     end
   end 
   
   def test_should_set_multiple_expectations_in_constructor
     mock = Mocha.new(:method1 => 1, :method2 => 2)
     assert_nothing_raised(Test::Unit::AssertionFailedError) do
       assert_equal 1, mock.method1
       assert_equal 2, mock.method2
     end
   end 
   
   def test_should_claim_to_respond_to_any_method
     mock = Mocha.new
     always_responds = mock.always_responds
     assert always_responds.respond_to?(:gobble_de_gook)
   end
   
   def test_should_raise_exception_if_attempting_to_mock_undefined_method
     mocked = Class.new
     mock = Mocha.new(mocked.new)
     assert_raise(Test::Unit::AssertionFailedError) do
       mock.expects(:method1)
     end
   end
   
   def test_should_not_raise_exception_if_attempting_to_mock_defined_method
     mocked = Class.new { def method1; end }
     mock = Mocha.new(mocked.new)
     assert_nothing_raised(Test::Unit::AssertionFailedError) do
       mock.expects(:method1)
     end
   end
   
   def test_should_not_raise_exception_if_attempting_to_mock_method_when_no_class_specified
     mock = Mocha.new
     assert_nothing_raised(Test::Unit::AssertionFailedError) do
       mock.expects(:method1)
     end
   end
   
   def test_should_build_and_store_expectations
     mock = Mocha.new
     expectation = mock.expects(:method1)
     assert_not_nil expectation
     assert_equal [expectation], mock.expectations
   end
   
end