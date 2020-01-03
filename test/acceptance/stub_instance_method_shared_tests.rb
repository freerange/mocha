require File.expand_path('../acceptance_test_helper', __FILE__)

module StubInstanceMethodSharedTests
  include AcceptanceTest

  def setup
    setup_acceptance_test
    method_owner.send(:define_method, :my_instance_method) { :original_return_value }
  end

  def teardown
    method_owner.send(:remove_method, :my_instance_method)
    teardown_acceptance_test
  end

  def test_should_stub_public_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:public)
  end

  def test_should_stub_protected_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:protected)
  end

  def test_should_stub_private_method_and_leave_it_unchanged_after_test
    assert_snapshot_unchanged_on_stubbing(:private)
  end

  def assert_snapshot_unchanged_on_stubbing(visibility)
    method_owner.send(visibility, :my_instance_method)
    instance = stubbed_class.new
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
