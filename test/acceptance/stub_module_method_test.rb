require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubModuleMethodTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    callee.singleton_class
  end

  def callee
    @callee ||= Module.new
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
