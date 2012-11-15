require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class StubInstanceMethodDefinedOnObjectClassTest < Test::Unit::TestCase

  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_stub_public_method_and_leave_it_unchanged_after_test
    Object.class_eval do
      def my_instance_method
        :original_return_value
      end
      public :my_instance_method
    end
    instance = Class.new.new
    assert_snapshot_unchanged(instance) do
      test_result = run_as_test do
        instance.stubs(:my_instance_method).returns(:new_return_value)
        assert_equal :new_return_value, instance.my_instance_method
      end
      assert_passed(test_result)
    end
    assert_equal :original_return_value, instance.my_instance_method
  ensure
    Object.class_eval { remove_method :my_instance_method }
  end

  def test_should_stub_protected_method_and_leave_it_unchanged_after_test
    Object.class_eval do
      def my_instance_method
        :original_return_value
      end
      protected :my_instance_method
    end
    instance = Class.new.new
    assert_snapshot_unchanged(instance) do
      test_result = run_as_test do
        instance.stubs(:my_instance_method).returns(:new_return_value)
        assert_equal :new_return_value, instance.send(:my_instance_method)
      end
      assert_passed(test_result)
    end
    assert_equal :original_return_value, instance.send(:my_instance_method)
  ensure
    Object.class_eval { remove_method :my_instance_method }
  end

  def test_should_stub_private_method_and_leave_it_unchanged_after_test
    Object.class_eval do
      def my_instance_method
        :original_return_value
      end
      private :my_instance_method
    end
    instance = Class.new.new
    assert_snapshot_unchanged(instance) do
      test_result = run_as_test do
        instance.stubs(:my_instance_method).returns(:new_return_value)
        assert_equal :new_return_value, instance.send(:my_instance_method)
      end
      assert_passed(test_result)
    end
    assert_equal :original_return_value, instance.send(:my_instance_method)
  ensure
    Object.class_eval { remove_method :my_instance_method }
  end
end
