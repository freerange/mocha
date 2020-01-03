require 'stub_method_shared_tests'

class StubModuleMethodTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Module.new
  end

  # rubocop:disable Lint/DuplicateMethods
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

  def test_should_be_able_to_stub_method_if_ruby18_public_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_mod = Module.new do
      class << self
        def public_methods(_include_superclass = true)
          ['my_module_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_mod.my_module_method
    end
    assert_passed(test_result)
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

  def test_should_be_able_to_stub_method_if_ruby_18_protected_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_mod = Module.new do
      class << self
        def protected_methods(_include_superclass = true)
          ['my_module_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_mod.my_module_method
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

  def test_should_be_able_to_stub_method_if_ruby18_private_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_mod = Module.new do
      class << self
        def private_methods(_include_superclass = true)
          ['my_module_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_mod.stubs(:my_module_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_mod.my_module_method
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
  # rubocop:enable Lint/DuplicateMethods
end
