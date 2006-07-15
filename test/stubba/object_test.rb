require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'stubba/object'

class ObjectTest < Test::Unit::TestCase
  
  include Stubba
  include Mocha
  
  def test_should_build_mocha
    instance = Object.new
    mocha = instance.mocha
    assert_not_nil mocha
    assert mocha.is_a?(Mock)
  end
  
  def test_should_reuse_existing_mocha
    instance = Object.new
    mocha_1 = instance.mocha
    mocha_2 = instance.mocha
    assert_equal mocha_1, mocha_2
  end
  
  def test_should_reset_mocha
    instance = Object.new
    assert_nil instance.reset_mocha
  end
  
  def test_should_stub_instance_method
    instance = Object.new
    stubba = Mock.new
    stubba.expects(:stub).with(InstanceMethod.new(instance, :method1))
    replace_stubba(stubba) do
      instance.expects(:method1)
    end
    stubba.verify(:stub)
  end 
  
  def test_should_build_and_store_expectation
    instance = Object.new
    stubba = Mock.new(:stub => nil)
    replace_stubba(stubba) do
      expectation = instance.expects(:method1)
      assert_equal [expectation], instance.mocha.expectations
    end
  end
  
  def test_should_verify_expectations
    instance = Object.new
    stubba = Mock.new(:stub => nil)
    replace_stubba(stubba) do
      instance.expects(:method1).with(:value1, :value2)
    end
    assert_raise(Test::Unit::AssertionFailedError) { instance.verify }
  end
  
  def test_should_build_any_instance_object
    klass = Class.new
    any_instance = klass.any_instance
    assert_not_nil any_instance
    assert any_instance.is_a?(Class::AnyInstance)
  end
  
  def test_should_return_same_any_instance_object
    klass = Class.new
    any_instance_1 = klass.any_instance
    any_instance_2 = klass.any_instance
    assert_equal any_instance_1, any_instance_2
  end
  
  def test_should_stub_class_method
    klass = Class.new
    stubba = Mock.new
    stubba.expects(:stub).with(ClassMethod.new(klass, :method1))
    replace_stubba(stubba) do
      klass.expects(:method1)
    end
    stubba.verify(:stub)
  end 
  
  def test_should_build_and_store_class_method_expectation
    klass = Class.new
    stubba = Mock.new(:stub => nil)
    replace_stubba(stubba) do
      expectation = klass.expects(:method1)
      assert_equal [expectation], klass.mocha.expectations
    end
  end
  
  def test_should_stub_module_method
    mod = Module.new
    stubba = Mock.new
    stubba.expects(:stub).with(ClassMethod.new(mod, :method1))
    replace_stubba(stubba) do
      mod.expects(:method1)
    end
    stubba.verify(:stub)
  end
  
  def test_should_build_and_store_module_method_expectation
    mod = Module.new
    stubba = Mock.new(:stub => nil)
    replace_stubba(stubba) do
      expectation = mod.expects(:method1)
      assert_equal [expectation], mod.mocha.expectations
    end
  end
  
  def test_should_use_stubba_instance_method_for_object
    assert_equal InstanceMethod, Object.new.stubba_method
  end
    
  def test_should_use_stubba_class_method_for_module
    assert_equal ClassMethod, Module.new.stubba_method
  end
    
  def test_should_use_stubba_class_method_for_class
    assert_equal ClassMethod, Class.new.stubba_method
  end
  
  def test_should_use_stubba_class_method_for_any_instance
    assert_equal AnyInstanceMethod, Class::AnyInstance.new(nil).stubba_method
  end
  
  def test_should_stub_self_for_object
    object = Object.new
    assert_equal object, object.stubba_object
  end
      
  def test_should_stub_self_for_module
    mod = Module.new
    assert_equal mod, mod.stubba_object
  end
      
  def test_should_stub_self_for_class
    klass = Class.new
    assert_equal klass, klass.stubba_object
  end
      
  def test_should_stub_relevant_class_for_any_instance
    klass = Class.new
    any_instance = Class::AnyInstance.new(klass)
    assert_equal klass, any_instance.stubba_object
  end
      
end