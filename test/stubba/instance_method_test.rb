require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'method_definer'

require 'stubba/instance_method'

class InstanceMethodTest < Test::Unit::TestCase
  
  include Stubba
   
  def test_should_exist
    klass = Class.new { def method_x; end }
    instance = klass.new
    method = InstanceMethod.new(instance, :method_x)
    
    assert method.exists?
  end
  
  def test_should_not_exist
    klass = Class.new { }
    instance = klass.new
    method = InstanceMethod.new(instance, :non_existent_method)
    
    assert !method.exists?
  end
  
  def test_should_raise_assertion_failed_error_when_attempting_to_stub_non_existent_method
    klass = Class.new
    instance = klass.new
    method = InstanceMethod.new(instance, :non_existent_method)
    assert_raise(Test::Unit::AssertionFailedError) { method.stub }
  end
  
  def test_should_call_define_new_method
    klass = Class.new { def method_x; end }
    instance = klass.new
    method = InstanceMethod.new(instance, :method_x)
    method.define_instance_accessor(:define_called)
    method.replace_instance_method(:define_new_method) { self.define_called = true }
    
    method.stub
    
    assert method.define_called
  end
    
  def test_should_not_call_hide_original_method
    klass = Class.new { def method_x; end }
    instance = klass.new
    method = InstanceMethod.new(instance, :method_x)
    method.replace_instance_method(:define_new_method) { }
    method.define_instance_accessor(:hide_called)
    method.replace_instance_method(:hide_original_method) { self.hide_called = true }
    
    method.stub
    
    assert !method.hide_called
  end
    
  def test_should_not_call_restore_original_method
    klass = Class.new { def method_x; end }
    instance = klass.new
    method = InstanceMethod.new(instance, :method_x)
    method.replace_instance_method(:define_new_method) { }
    method.define_instance_accessor(:restore_called)
    method.replace_instance_method(:restore_original_method) { self.restore_called = true }
    
    method.unstub
    
    assert !method.restore_called
  end
  
  def test_should_not_call_remove_new_method
    klass = Class.new { def method_x; end }
    instance = klass.new
    method = InstanceMethod.new(instance, :method_x)
    method.replace_instance_method(:define_new_method) { }
    method.define_instance_accessor(:remove_called)
    method.replace_instance_method(:remove_new_method) { self.remove_called = true }
    
    method.unstub
    
    assert !method.remove_called
  end
  
  def test_should_not_call_reset_mocha
    klass = Class.new { def method_x; end }
    instance = klass.new
    instance.define_instance_accessor(:reset_called)
    instance.define_instance_method(:reset_mocha) { self.reset_called = true }
    method = InstanceMethod.new(instance, :method_x)
    method.replace_instance_method(:define_new_method) { }
    
    method.unstub
    
    assert !instance.reset_called
  end
  
end