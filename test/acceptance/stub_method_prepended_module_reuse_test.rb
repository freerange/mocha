# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class StubMethodPrependedModuleReuseTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_not_add_to_ancestors_of_singleton_class_each_time_class_method_is_stubbed
    klass = Class.new do
      def self.my_class_method
        :original_return_value
      end
    end
    stub_class_method = lambda do
      run_as_test do
        klass.stubs(:my_class_method).returns(:stubbed_return_value)
        assert_equal :stubbed_return_value, klass.my_class_method
      end
    end
    assert_passed(stub_class_method.call)
    number_of_ancestors = klass.singleton_class.ancestors.length

    3.times { assert_passed(stub_class_method.call) }

    assert_equal number_of_ancestors, klass.singleton_class.ancestors.length
    assert_equal :original_return_value, klass.my_class_method
  end

  def test_should_not_add_to_ancestors_of_class_each_time_any_instance_method_is_stubbed
    klass = Class.new do
      def my_instance_method
        :original_return_value
      end
    end
    stub_any_instance_method = lambda do
      run_as_test do
        klass.any_instance.stubs(:my_instance_method).returns(:stubbed_return_value)
        assert_equal :stubbed_return_value, klass.new.my_instance_method
      end
    end
    assert_passed(stub_any_instance_method.call)
    number_of_ancestors = klass.ancestors.length

    3.times { assert_passed(stub_any_instance_method.call) }

    assert_equal number_of_ancestors, klass.ancestors.length
    assert_equal :original_return_value, klass.new.my_instance_method
  end

  def test_should_not_reuse_prepended_module_when_another_module_has_been_prepended_since
    klass = Class.new do
      def self.my_class_method
        :original_return_value
      end
    end
    assert_passed(run_as_test { klass.stubs(:my_class_method).returns(:stubbed_return_value) })
    klass.singleton_class.prepend(Module.new do
      def my_class_method
        [:prepended, super]
      end
    end)

    test_result = run_as_test do
      klass.stubs(:my_class_method).returns(:stubbed_return_value)
      assert_equal :stubbed_return_value, klass.my_class_method
    end

    assert_passed(test_result)
    assert_equal [:prepended, :original_return_value], klass.my_class_method
  end

  def test_should_not_reuse_prepended_module_already_stubbing_method_with_same_name
    klass = Class.new do
      def self.my_class_method
        :original_return_value
      end
    end
    test_result = run_as_test do
      klass.stubs(:my_class_method).returns(:stubbed_return_value)
      klass.singleton_class.any_instance.stubs(:my_class_method).returns(:other_stubbed_return_value)
      assert_equal :other_stubbed_return_value, klass.my_class_method
    end
    assert_passed(test_result)
    assert_equal :original_return_value, klass.my_class_method
  end
end
