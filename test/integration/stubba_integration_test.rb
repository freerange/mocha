require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha'
require 'test_runner'

class StubbaIntegrationTest < Test::Unit::TestCase
  
  class DontMessWithMe
    def self.my_class_method
      :original_return_value
    end
    def my_instance_method
      :original_return_value
    end
  end
  
  include TestRunner
  
  def test_should_stub_class_method_within_test
    test_result = run_test do
      DontMessWithMe.expects(:my_class_method).returns(:new_return_value)
      assert_equal :new_return_value, DontMessWithMe.my_class_method
    end
    assert_passed(test_result)
  end

  def test_should_leave_stubbed_class_method_unchanged_after_test
    run_test do
      DontMessWithMe.expects(:my_class_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, DontMessWithMe.my_class_method
  end
  
  def test_should_reset_class_expectations_after_test
    run_test do
      DontMessWithMe.expects(:my_class_method)
    end
    assert_equal 0, DontMessWithMe.mocha.expectations.length
  end  

  def test_should_stub_instance_method_within_test
    instance = DontMessWithMe.new
    test_result = run_test do
      instance.expects(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, instance.my_instance_method
    end
    assert_passed(test_result)
  end
  
  def test_should_leave_stubbed_instance_method_unchanged_after_test
    instance = DontMessWithMe.new
    run_test do
      instance.expects(:my_instance_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, instance.my_instance_method
  end
  
  def test_should_reset_instance_expectations_after_test
    instance = DontMessWithMe.new
    run_test do
      instance.expects(:my_instance_method).returns(:new_return_value)
    end
    assert_equal 0, instance.mocha.expectations.length
  end  

end