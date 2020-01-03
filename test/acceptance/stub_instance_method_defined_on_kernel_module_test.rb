require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnKernelModuleTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def stubbed_module
    Kernel
  end

  def stubbed_class
    Class.new
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
end
