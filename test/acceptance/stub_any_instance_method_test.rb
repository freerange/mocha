require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubAnyInstanceMethodTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def callee
    method_owner.new
  end

  def stubbee
    method_owner.any_instance
  end

  def test_should_reset_expectations_after_test
    klass = Class.new do
      def my_instance_method
        :original_return_value
      end
    end
    run_as_test do
      klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
    end

    assert_equal 0, klass.any_instance.mocha.__expectations__.length
  end

  # rubocop:disable Lint/DuplicateMethods
  def test_should_be_able_to_stub_method_if_ruby18_public_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_klass = Class.new do
      class << self
        def public_instance_methods(_include_superclass = true)
          ['my_instance_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_klass.new.my_instance_method
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby19_public_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_klass = Class.new do
      class << self
        def public_instance_methods(_include_superclass = true)
          [:my_instance_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_klass.new.my_instance_method
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby18_protected_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_klass = Class.new do
      class << self
        def protected_instance_methods(_include_superclass = true)
          ['my_instance_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_klass.new.send(:my_instance_method)
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby19_protected_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_klass = Class.new do
      class << self
        def protected_instance_methods(_include_superclass = true)
          [:my_instance_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_klass.new.send(:my_instance_method)
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby18_private_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby18_klass = Class.new do
      class << self
        def private_instance_methods(_include_superclass = true)
          ['my_instance_method']
        end
      end
    end
    test_result = run_as_test do
      ruby18_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby18_klass.new.send(:my_instance_method)
    end
    assert_passed(test_result)
  end

  def test_should_be_able_to_stub_method_if_ruby19_private_instance_methods_include_method_but_method_does_not_actually_exist_like_active_record_association_proxy
    ruby19_klass = Class.new do
      class << self
        def private_instance_methods(_include_superclass = true)
          [:my_instance_method]
        end
      end
    end
    test_result = run_as_test do
      ruby19_klass.any_instance.stubs(:my_instance_method).returns(:new_return_value)
      assert_equal :new_return_value, ruby19_klass.new.send(:my_instance_method)
    end
    assert_passed(test_result)
  end
  # rubocop:enable Lint/DuplicateMethods
end

class StubAnyInstanceMethodOriginallyPrivateInOwningModuleTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new.send(:include, module_with_private_method)
  end

  def callee
    method_owner.new
  end

  def stubbee
    method_owner.any_instance
  end

  def module_with_private_method
    mod = Module.new
    mod.send(:define_method, stubbed_method_name) { :private_module_method_return_value }
    mod.send(:private, stubbed_method_name)
    mod
  end
end
