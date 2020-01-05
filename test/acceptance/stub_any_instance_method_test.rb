require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubAnyInstanceMethodTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    method_owner.new
  end

  def stub_owner
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

  def test_should_be_able_to_stub_a_public_superclass_method
    superklass = Class.new do
      def my_superclass_method
        :original_return_value
      end
      public :my_superclass_method
    end
    klass = Class.new(superklass)
    instance = klass.new
    test_result = run_as_test do
      klass.any_instance.stubs(:my_superclass_method).returns(:new_return_value)
      assert_method_visibility instance, :my_superclass_method, :public
      assert_equal :new_return_value, instance.my_superclass_method
    end
    assert_passed(test_result)
    assert(instance.public_methods(true).any? { |m| m.to_s == 'my_superclass_method' })
    assert(klass.public_methods(false).none? { |m| m.to_s == 'my_superclass_method' })
    assert_equal :original_return_value, instance.my_superclass_method
  end

  def test_should_be_able_to_stub_a_protected_superclass_method
    superklass = Class.new do
      def my_superclass_method
        :original_return_value
      end
      protected :my_superclass_method
    end
    klass = Class.new(superklass)
    instance = klass.new
    test_result = run_as_test do
      klass.any_instance.stubs(:my_superclass_method).returns(:new_return_value)
      assert_method_visibility instance, :my_superclass_method, :protected
      assert_equal :new_return_value, instance.send(:my_superclass_method)
    end
    assert_passed(test_result)
    assert(instance.protected_methods(true).any? { |m| m.to_s == 'my_superclass_method' })
    assert(klass.protected_methods(false).none? { |m| m.to_s == 'my_superclass_method' })
    assert_equal :original_return_value, instance.send(:my_superclass_method)
  end

  def test_should_be_able_to_stub_a_private_superclass_method
    superklass = Class.new do
      def my_superclass_method
        :original_return_value
      end
      private :my_superclass_method
    end
    klass = Class.new(superklass)
    instance = klass.new
    test_result = run_as_test do
      klass.any_instance.stubs(:my_superclass_method).returns(:new_return_value)
      assert_method_visibility instance, :my_superclass_method, :private
      assert_equal :new_return_value, instance.send(:my_superclass_method)
    end
    assert_passed(test_result)
    assert(instance.private_methods(true).any? { |m| m.to_s == 'my_superclass_method' })
    assert(klass.private_methods(false).none? { |m| m.to_s == 'my_superclass_method' })
    assert_equal :original_return_value, instance.send(:my_superclass_method)
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

  def stubbed_instance
    method_owner.new
  end

  def stub_owner
    method_owner.any_instance
  end

  def module_with_private_method
    mod = Module.new
    mod.send(:define_method, stubbed_method_name) { :private_module_method_return_value }
    mod.send(:private, stubbed_method_name)
    mod
  end
end
