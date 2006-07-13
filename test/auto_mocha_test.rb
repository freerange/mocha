require 'test_helper'
require 'auto_mocha'

class AutoMochaTest < Test::Unit::TestCase
  
  def setup
    reset_mochas
  end
  
  def test_should_reset_mochas
    undefined_class = UndefinedClass
    reset_mochas
    assert_not_same undefined_class, UndefinedClass
  end
  
  def test_should_refer_to_same_class
    defined_class = Class.new { def self.undefined_class; UndefinedClass; end }
    assert_same UndefinedClass, defined_class.undefined_class
  end
  
  def test_should_refer_to_same_parent_class
    defined_class = Class.new(UndefinedClass)
    assert_same UndefinedClass, defined_class.superclass
  end
  
  def test_should_refer_to_same_namespaced_class
    defined_class = Class.new { def self.namespaced_class; Namespace::UndefinedClass; end }
    assert_same Namespace::UndefinedClass, defined_class.namespaced_class
  end
  
  def test_should_refer_to_different_namespaced_classes_within_test
    assert ! NamespaceOne::UndefinedClass.equal?(NamespaceTwo::UndefinedClass)
  end
     
  def test_should_refer_to_different_namespaced_classes_within_class_under_test
    defined_class = Class.new {
      def self.class_in_namespace_one; NamespaceOne::UndefinedClass; end
      def self.class_in_namespace_two; NamespaceTwo::UndefinedClass; end
    }
    assert ! defined_class.class_in_namespace_one.equal?(defined_class.class_in_namespace_two)
  end
  
  def test_should_refer_to_same_class_within_instance_under_test
    defined_class = Class.new(UndefinedClassOne) { def undefined_class_two; UndefinedClassTwo; end }
    instance = defined_class.new
    assert_same UndefinedClassTwo, instance.undefined_class_two
  end
  
  def test_should_verify_all_root_mochas_when_second_method_is_not_called
    ClassOne.expects(:first)
    ClassTwo.expects(:second)
    ClassOne.first
    assert_raise(Test::Unit::AssertionFailedError) {
      verify_all
    }
  end
  
  def test_should_verify_all_root_mochas_when_first_method_is_not_called
    ClassOne.expects(:first)
    ClassTwo.expects(:second)
    ClassTwo.second
    assert_raise(Test::Unit::AssertionFailedError) {
      verify_all
    }
  end
  
  def test_should_verify_all_namespaced_mochas_when_second_method_is_not_called
    NamespaceOne::ClassOne.expects(:first)
    NamespaceTwo::ClassTwo.expects(:second)
    NamespaceOne::ClassOne.first
    assert_raise(Test::Unit::AssertionFailedError) {
      verify_all
    }
  end
  
  def test_should_verify_all_namespaced_mochas_when_first_method_is_not_called
    NamespaceOne::ClassOne.expects(:first)
    NamespaceTwo::ClassTwo.expects(:second)
    NamespaceTwo::ClassTwo.second
    assert_raise(Test::Unit::AssertionFailedError) {
      verify_all
    }
  end
  
end