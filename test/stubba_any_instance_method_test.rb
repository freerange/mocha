require 'test_helper'
require 'mocha/stubba_any_instance_method'
require 'mocha/mocha'

class StubbaAnyInstanceMethodTest < Test::Unit::TestCase
  
  def test_should_hide_original_method
    klass = Class.new { def method_x; end }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    
    method.hide_original_method
    
    assert klass.method_defined?(hidden_method_x)
  end
  
  def test_should_not_hide_original_method_if_it_is_not_defined
    klass = Class.new
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    
    method.hide_original_method
    
    assert_equal false, klass.method_defined?(hidden_method_x)
  end
  
  def test_should_define_a_new_method
    klass = Class.new { def method_x; end } 
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    mocha = Mocha.new
    mocha.expects(:method_x).with(:param1, :param2).returns(:result)
    any_instance = Mocha.new(:mocha => mocha)
    klass.define_instance_method(:any_instance) { any_instance }
    
    method.define_new_method

    instance = klass.new
    result = instance.method_x(:param1, :param2)
        
    assert_equal :result, result
    mocha.verify
  end

  def test_should_restore_original_method
    klass = Class.new { def method_x; end }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    klass.send(:define_method, hidden_method_x, Proc.new { :original_result }) 
    
    method.restore_original_method
    
    instance = klass.new
    assert_equal :original_result, instance.method_x 
    assert !klass.method_defined?(hidden_method_x)
  end

  def test_should_not_restore_original_method_if_hidden_method_not_defined
    klass = Class.new { def method_x; :new_result; end }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    
    method.restore_original_method
    
    instance = klass.new
    assert_equal :new_result, instance.method_x 
  end

  def test_should_call_remove_new_method
    klass = Class.new { def method_x; end }
    any_instance = Mocha.new(:reset_mocha => nil)
    klass.define_instance_method(:any_instance) { any_instance }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:restore_original_method) { }
    method.define_instance_accessor(:remove_called)
    method.replace_instance_method(:remove_new_method) { self.remove_called = true }
    
    method.unstub
    
    assert method.remove_called
  end

  def test_should_call_restore_original_method
    klass = Class.new { def method_x; end }
    any_instance = Mocha.new(:reset_mocha => nil)
    klass.define_instance_method(:any_instance) { any_instance }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:remove_new_method) { }
    method.define_instance_accessor(:restore_called)
    method.replace_instance_method(:restore_original_method) { self.restore_called = true }
    
    method.unstub
    
    assert method.restore_called
  end

  def test_should_call_reset_mocha
    klass = Class.new { def method_x; end }
    any_instance = Mocha.new(:reset_mocha => nil)
    klass.define_instance_method(:any_instance) { any_instance }
    method = StubbaAnyInstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:remove_new_method) { }
    method.replace_instance_method(:restore_original_method) { }
    
    method.unstub

    any_instance.verify(:reset_mocha)
  end

end