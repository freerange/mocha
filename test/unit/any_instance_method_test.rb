require File.expand_path('../../test_helper', __FILE__)
require 'method_definer'
require 'mocha/mock'
require 'mocha/any_instance_method'

class AnyInstanceMethodTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_hide_original_method
    klass = Class.new { def method_x; end }
    method = AnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    
    method.hide_original_method
    
    assert klass.method_defined?(hidden_method_x)
  end
  
  def test_should_not_hide_original_method_if_it_is_not_defined
    klass = Class.new
    method = AnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    
    method.hide_original_method
    
    assert_equal false, klass.method_defined?(hidden_method_x)
  end
  
  def test_should_define_a_new_method
    klass = Class.new { def method_x; end } 
    method = AnyInstanceMethod.new(klass, :method_x)
    mocha = build_mock
    mocha.expects(:method_x).with(:param1, :param2).returns(:result)
    any_instance = Object.new
    any_instance.define_instance_method(:mocha) { mocha }
    klass.define_instance_method(:any_instance) { any_instance }
    
    method.hide_original_method
    method.define_new_method

    instance = klass.new
    result = instance.method_x(:param1, :param2)
        
    assert_equal :result, result
    assert mocha.__verified__?
  end

  def test_should_restore_original_method
    klass = Class.new { def method_x; end }
    method = AnyInstanceMethod.new(klass, :method_x)
    hidden_method_x = method.hidden_method.to_sym
    klass.send(:define_method, hidden_method_x, Proc.new { :original_result }) 
    
    method.remove_new_method
    method.restore_original_method
    
    instance = klass.new
    assert_equal :original_result, instance.method_x 
    assert !klass.method_defined?(hidden_method_x)
  end

  def test_should_not_restore_original_method_if_hidden_method_not_defined
    klass = Class.new { def method_x; :new_result; end }
    method = AnyInstanceMethod.new(klass, :method_x)
    
    method.restore_original_method
    
    instance = klass.new
    assert_equal :new_result, instance.method_x 
  end

  def test_should_call_remove_new_method
    klass = Class.new { def method_x; end }
    any_instance = build_mock
    any_instance_mocha = build_mock
    any_instance.stubs(:mocha).returns(any_instance_mocha)
    klass.define_instance_method(:any_instance) { any_instance }
    method = AnyInstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:restore_original_method) { }
    method.define_instance_accessor(:remove_called)
    method.replace_instance_method(:remove_new_method) { self.remove_called = true }
    
    method.unstub
    
    assert method.remove_called
  end

  def test_should_call_restore_original_method
    klass = Class.new { def method_x; end }
    any_instance = build_mock
    any_instance_mocha = build_mock
    any_instance.stubs(:mocha).returns(any_instance_mocha)
    klass.define_instance_method(:any_instance) { any_instance }
    method = AnyInstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:remove_new_method) { }
    method.define_instance_accessor(:restore_called)
    method.replace_instance_method(:restore_original_method) { self.restore_called = true }
    
    method.unstub
    
    assert method.restore_called
  end

  def test_should_call_mock_unstub
    klass = Class.new { def method_x; end }

    method = AnyInstanceMethod.new(klass, :method_x)

    method.replace_instance_method(:remove_new_method) { }
    method.replace_instance_method(:restore_original_method) { }
    mocha = Class.new { class << self; attr_accessor :unstub_method; end; def self.unstub(method); self.unstub_method = method; end; }
    mocha.define_instance_method(:any_expectations?) { true }
    method.replace_instance_method(:mock) { mocha }

    method.unstub

    assert_equal mocha.unstub_method, :method_x
  end

  def test_should_return_any_instance_mocha_for_stubbee
    mocha = Object.new
    any_instance = Object.new
    any_instance.define_instance_method(:mocha) { mocha }
    stubbee = Class.new
    stubbee.define_instance_method(:any_instance) { any_instance }
    method = AnyInstanceMethod.new(stubbee, :method_name)
    assert_equal stubbee.any_instance.mocha, method.mock
  end

  private

  def build_mock
    Mock.new(nil)
  end
end
