require File.expand_path('../acceptance_test_helper', __FILE__)

class StubInstanceMethodDefinedOnKernelModuleTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
    Kernel.send(:define_method, :my_instance_method) { :original_return_value }
  end

  def teardown
    Kernel.send(:remove_method, :my_instance_method)
    teardown_acceptance_test
  end

  def test_should_stub_public_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:public, Class.new.new)
  end

  def test_should_stub_protected_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:protected, Class.new.new)
  end

  def test_should_stub_private_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:private, Class.new.new)
  end

  def test_should_stub_public_module_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:public, Module.new)
  end

  def test_should_stub_protected_module_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:protected, Module.new)
  end

  def test_should_stub_private_module_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:private, Module.new)
  end

  def assert_snapshot_unchanged_on_stubbing(visibility, instance)
    Kernel.send(visibility, :my_instance_method)
    assert_snapshot_unchanged(instance) do
      test_result = run_as_test do
        instance.stubs(:my_instance_method).returns(:new_return_value)
        assert_method_visibility instance, :my_instance_method, visibility
        assert_equal :new_return_value, instance.send(:my_instance_method)
      end
      assert_passed(test_result)
    end
    assert_equal :original_return_value, instance.send(:my_instance_method)
  end
end
