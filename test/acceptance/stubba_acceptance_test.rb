require File.join(File.dirname(__FILE__), "acceptance_test_helper")
require 'mocha'
 
class StubbaAcceptanceTest < Test::Unit::TestCase

  include AcceptanceTest
   
  def setup
    setup_acceptance_test
  end
  
  def teardown
    teardown_acceptance_test
  end
  
  def test_should_stub_class_method_within_test
    klass = Class.new { def self.my_class_method; :original_return_value; end }
    test_result = run_test do
      klass.stubs(:my_class_method).returns(:new_return_value)
      assert_equal :new_return_value, klass.my_class_method
    end
    assert_passed(test_result)
  end
  
  def test_should_leave_stubbed_public_class_method_unchanged_after_test
    klass = Class.new { class << self; def my_class_method; :original_return_value; end; public :my_class_method; end }
    run_test do
      klass.stubs(:my_class_method).returns(:new_return_value)
    end
    assert klass.public_methods.any? { |m| m.to_s == 'my_class_method' }
    assert_equal :original_return_value, klass.my_class_method
  end
  
  def test_should_leave_stubbed_protected_class_method_unchanged_after_test
    klass = Class.new { class << self; def my_class_method; :original_return_value; end; protected :my_class_method; end }
    run_test do
      klass.stubs(:my_class_method).returns(:new_return_value)
    end
    assert klass.protected_methods.any? { |m| m.to_s == 'my_class_method' }
    assert_equal :original_return_value, klass.send(:my_class_method)
  end
  
  # def test_should_leave_stubbed_private_class_method_unchanged_after_test
  #   klass = Class.new { class << self; def my_class_method; :original_return_value; end; private :my_class_method; end }
  #   run_test do
  #     klass.stubs(:my_class_method).returns(:new_return_value)
  #   end
  #   assert klass.private_methods.any? { |m| m.to_s == 'my_class_method' }
  #   assert_equal :original_return_value, klass.send(:my_class_method)
  # end
  
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
  
  def test_should_leave_stubbed_public_module_method_unchanged_after_test
    mod = Module.new { class << self; def my_module_method; :original_return_value; end; public :my_module_method; end }
    run_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert mod.public_methods.any? { |m| m.to_s == 'my_module_method' }
    assert_equal :original_return_value, mod.my_module_method
  end
  
  def test_should_leave_stubbed_protected_module_method_unchanged_after_test
    mod = Module.new { class << self; def my_module_method; :original_return_value; end; protected :my_module_method; end }
    run_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert mod.protected_methods.any? { |m| m.to_s == 'my_module_method' }
    assert_equal :original_return_value, mod.send(:my_module_method)
  end
  
  # def test_should_leave_stubbed_private_module_method_unchanged_after_test
  #   mod = Module.new { class << self; def my_module_method; :original_return_value; end; private :my_module_method; end }
  #   run_test do
  #     mod.stubs(:my_module_method).returns(:new_return_value)
  #   end
  #   assert mod.private_methods.any? { |m| m.to_s == 'my_module_method' }
  #   assert_equal :original_return_value, mod.send(:my_module_method)
  # end
  
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
  
  def test_should_leave_stubbed_public_instance_method_unchanged_after_test
    instance = Class.new { def my_instance_method; :original_return_value; end; public :my_instance_method }.new
    run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert instance.public_methods.any? { |m| m.to_s == 'my_instance_method' }
    assert_equal :original_return_value, instance.my_instance_method
  end
  
  def test_should_leave_stubbed_protected_instance_method_unchanged_after_test
    instance = Class.new { def my_instance_method; :original_return_value; end; protected :my_instance_method }.new
    run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert instance.protected_methods.any? { |m| m.to_s == 'my_instance_method' }
    assert_equal :original_return_value, instance.send(:my_instance_method)
  end
  
  def test_should_leave_stubbed_private_instance_method_unchanged_after_test
    instance = Class.new { def my_instance_method; :original_return_value; end; private :my_instance_method }.new
    run_test do
      instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert instance.private_methods.any? { |m| m.to_s == 'my_instance_method' }
    assert_equal :original_return_value, instance.send(:my_instance_method)
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
  
  def test_should_leave_stubbed_any_instance_public_method_unchanged_after_test
    klass = Class.new { def my_instance_method; :original_return_value; end; public :my_instance_method }
    instance = klass.new
    run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert instance.public_methods.any? { |m| m.to_s == 'my_instance_method' }
    assert_equal :original_return_value, instance.my_instance_method
  end
  
  def test_should_leave_stubbed_any_instance_protected_method_unchanged_after_test
    klass = Class.new { def my_instance_method; :original_return_value; end; protected :my_instance_method }
    instance = klass.new
    run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert instance.protected_methods.any? { |m| m.to_s == 'my_instance_method' }
    assert_equal :original_return_value, instance.send(:my_instance_method)
  end
  
  # def test_should_leave_stubbed_any_instance_private_method_unchanged_after_test
  #   klass = Class.new { def my_instance_method; :original_return_value; end; private :my_instance_method }
  #   instance = klass.new
  #   run_test do
  #     klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
  #   end
  #   assert instance.private_methods.any? { |m| m.to_s == 'my_instance_method' }
  #   assert_equal :original_return_value, instance.send(:my_instance_method)
  # end
  
  def test_should_reset_any_instance_expectations_after_test
    klass = Class.new { def my_instance_method; :original_return_value; end }
    instance = klass.new
    run_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end
    assert_equal 0, klass.any_instance.mocha.expectations.length
  end  
  
end