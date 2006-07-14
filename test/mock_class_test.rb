require 'test_helper' 
require 'mocha/mock_class'

class MockClassTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_not_expect_unexpected_class_method_call
    klass = MockClass.dup
    assert_raise(Test::Unit::AssertionFailedError) {
      klass.unexpected_class_method
    }
  end
  
  def test_should_expect_expected_class_method_call
    klass = MockClass.dup
    klass.expects(:expected_class_method)
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      klass.expected_class_method
    }
  end
  
  def test_should_fail_verification_for_missing_class_method_call
    klass = MockClass.dup
    klass.expects(:expected_class_method)
    assert_raise(Test::Unit::AssertionFailedError) {
      klass.verify
    }
  end
   
  def test_should_verify_expected_class_method_call
    klass = MockClass.dup
    klass.expects(:expected_class_method)
    klass.expected_class_method
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      klass.verify
    }
  end
  
  def test_should_not_expect_unexpected_child_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    assert_raise(Test::Unit::AssertionFailedError) {
      child_class.unexpected_child_class_method
    }
  end
  
  def test_should_expect_child_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_class.expects(:expected_child_class_method)
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      child_class.expected_child_class_method
    }
  end
  
  def test_should_fail_verification_for_missing_child_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_class.expects(:expected_child_class_method)
    assert_raise(Test::Unit::AssertionFailedError) {
      child_class.verify
    }
  end
  
  def test_should_verify_expected_child_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_class.expects(:expected_child_class_method)
    child_class.expected_child_class_method
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      child_class.verify
    }
  end
  
  def test_should_not_expect_unexpected_parent_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    assert_raise(Test::Unit::AssertionFailedError) {
      child_class.unexpected_parent_class_method
    }
  end
  
  def test_should_expect_parent_class_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    parent_class.expects(:expected_parent_class_method)
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      child_class.expected_parent_class_method
    }
  end
  
  def test_should_fail_verification_for_missing_parent_class_method
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    parent_class.expects(:expected_parent_class_method)
    assert_raise(Test::Unit::AssertionFailedError) {
      parent_class.verify
    }
  end
  
  def test_should_verify_expected_parent_class_method_call_from_child_class
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    parent_class.expects(:expected_parent_class_method)
    child_class.expected_parent_class_method
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      parent_class.verify
    }
  end
  
  def test_should_have_different_expectations_for_different_descendant_classes
    klass1 = MockClass.dup
    klass2 = MockClass.dup
    klass2.expects(:my_class_method)
    assert_raise(Test::Unit::AssertionFailedError) {
      klass1.my_class_method
    }
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      klass2.my_class_method
    }
  end
  
  def test_should_allow_mocking_of_class_constructor
    klass = MockClass.dup
    expected_instance = Object.new
    klass.expects(:new).returns(expected_instance)
    assert_same expected_instance, klass.new
  end
  
  def test_should_use_original_constructor_for_derived_classes
    parent_class = MockClass.dup
    child_class = Class.new(parent_class) { attr_reader :p1, :p2; def initialize(p1, p2); @p1, @p2 = p1, p2; end }
    child_instance = child_class.new(1, 2)
    assert_equal 1, child_instance.p1
    assert_equal 2, child_instance.p2
  end
  
  def test_should_not_expect_unexpected_parent_instance_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_instance = child_class.new
    assert_raise(Test::Unit::AssertionFailedError) {
      child_instance.unexpected_parent_instance_method
    }    
  end
  
  def test_should_expect_expected_parent_instance_method_call
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_instance = child_class.new
    child_instance.expects(:expected_parent_instance_method)
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      child_instance.expected_parent_instance_method
    }    
  end
  
  def test_should_fail_verification_for_missing_parent_instance_method
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_instance = child_class.new
    child_instance.expects(:expected_parent_instance_method)
    assert_raise(Test::Unit::AssertionFailedError) {
      child_instance.verify
    }
  end
  
  def test_should_verify_expected_parent_class_method_call_from_child_class
    parent_class = MockClass.dup
    child_class = Class.new(parent_class)
    child_instance = child_class.new
    child_instance.expects(:expected_parent_instance_method)
    child_instance.expected_parent_instance_method
    assert_nothing_raised(Test::Unit::AssertionFailedError) {
      child_instance.verify
    }
  end
  
end  