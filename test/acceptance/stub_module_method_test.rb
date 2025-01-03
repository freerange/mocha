# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class StubModuleMethodTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_stub_method_within_test
    mod = Module.new do
      def self.my_module_method
        :original_return_value
      end
    end
    test_result = run_as_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, mod.my_module_method
    end
    assert_passed(test_result)
  end

  def test_should_leave_stubbed_public_method_unchanged_after_test
    mod = Module.new do
      class << self
        def my_module_method
          :original_return_value
        end
        public :my_module_method
      end
    end
    run_as_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert(mod.public_methods(false).any? { |m| m.to_s == 'my_module_method' })
    assert_equal :original_return_value, mod.my_module_method
  end

  def test_should_leave_stubbed_protected_method_unchanged_after_test
    mod = Module.new do
      class << self
        def my_module_method
          :original_return_value
        end
        protected :my_module_method
        def my_unprotected_module_method
          my_module_method
        end
      end
    end
    run_as_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert(mod.protected_methods(false).any? { |m| m.to_s == 'my_module_method' })
    assert_equal :original_return_value, mod.my_unprotected_module_method
  end

  def test_should_leave_stubbed_private_method_unchanged_after_test
    mod = Module.new do
      class << self
        def my_module_method
          :original_return_value
        end
        private :my_module_method
      end
    end
    run_as_test do
      mod.stubs(:my_module_method).returns(:new_return_value)
    end
    assert(mod.private_methods(false).any? { |m| m.to_s == 'my_module_method' })
    assert_equal :original_return_value, mod.send(:my_module_method)
  end

  def test_should_reset_expectations_after_test
    mod = Module.new do
      def self.my_module_method
        :original_return_value
      end
    end
    run_as_test do
      mod.stubs(:my_module_method)
    end
    assert_equal 0, mod.mocha.__expectations__.length
  end

  def test_should_be_able_to_stub_a_superclass_method
    supermod = Module.new do
      def self.my_superclass_method
        :original_return_value
      end
    end
    mod = Module.new do
      include supermod
    end
    test_result = run_as_test do
      mod.stubs(:my_superclass_method).returns(:new_return_value)
      assert_equal :new_return_value, mod.my_superclass_method
    end
    assert_passed(test_result)
    assert(supermod.public_methods.any? { |m| m.to_s == 'my_superclass_method' })
    assert(mod.public_methods(false).none? { |m| m.to_s == 'my_superclass_method' })
    assert_equal :original_return_value, supermod.my_superclass_method
  end

  def test_should_be_able_to_stub_method_if_ruby19_public_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_mod = Module.new do
      class << self
        def public_methods(_include_superclass = true)
          [:my_module_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_mod.my_module_method
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby19_protected_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_mod = Module.new do
      class << self
        def protected_methods(_include_superclass = true)
          [:my_module_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_mod.my_module_method
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby19_private_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_mod = Module.new do
      class << self
        def private_methods(_include_superclass = true)
          [:my_module_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_mod.my_module_method
    end
    assert_passed(test_result)
  end
end
