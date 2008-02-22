require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha'
require 'test_runner'

class StubbaAcceptanceTest < Test::Unit::TestCase
  
  include TestRunner
  
  def test_should_stub_class_method_within_test
    klass = Class.new { def self.my_class_method; :original_return_value; end }
    test_result = run_test do
      klass.stubs(:my_class_method).returns(:new_return_value)
      assert_equal :new_return_value, klass.my_class_method
    end
    assert_passed(test_result)
  end

  def test_should_leave_stubbed_class_method_unchanged_after_test
    klass = Class.new { def self.my_class_method; :original_return_value; end }
    run_test do
      klass.stubs(:my_class_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, klass.my_class_method
  end
  
  def test_should_reset_class_expectations_after_test
    klass = Class.new { def self.my_class_method; :original_return_value; end }
    run_test do
      klass.stubs(:my_class_method)
    end
    assert_equal 0, klass.mocha.expectations.length
  end  

  def test_should_stub_module_method_within_test
    mod = Module.new { def self.my_module_method; :original_return_value; end }
    test_result = run_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, mod.my_module_method
    end
    assert_passed(test_result)
  end

  def test_should_leave_stubbed_module_method_unchanged_after_test
    mod = Module.new { def self.my_module_method; :original_return_value; end }
    run_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, mod.my_module_method
  end
  
  def test_should_reset_module_expectations_after_test
    mod = Module.new { def self.my_module_method; :original_return_value; end }
    run_test do
      mod.stubs(:my_module_method)
    end
    assert_equal 0, mod.mocha.expectations.length
  end  

  def test_should_stub_instance_method_within_test
    instance = Class.new { def my_instance_method; :original_return_value; end }.new
    test_result = run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, instance.my_instance_method
    end
    assert_passed(test_result)
  end
  
  def test_should_leave_stubbed_instance_method_unchanged_after_test
    instance = Class.new { def my_instance_method; :original_return_value; end }.new
    run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, instance.my_instance_method
  end
  
  def test_should_reset_instance_expectations_after_test
    instance = Class.new { def my_instance_method; :original_return_value; end }.new
    run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert_equal 0, instance.mocha.expectations.length
  end  

  def test_should_stub_any_instance_method_within_test
    klass = Class.new { def my_instance_method; :original_return_value; end }
    instance = klass.new
    test_result = run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, instance.my_instance_method
    end
    assert_passed(test_result)
  end
  
  def test_should_leave_stubbed_any_instance_method_unchanged_after_test
    klass = Class.new { def my_instance_method; :original_return_value; end }
    instance = klass.new
    run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert_equal :original_return_value, instance.my_instance_method
  end
  
  def test_should_reset_any_instance_expectations_after_test
    klass = Class.new { def my_instance_method; :original_return_value; end }
    instance = klass.new
    run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert_equal 0, klass.any_instance.mocha.expectations.length
  end  
  
end