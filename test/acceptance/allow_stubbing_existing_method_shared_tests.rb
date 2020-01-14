require File.expand_path('../acceptance_test_helper', __FILE__)

module AllowStubbingExistingMethodSharedTests
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_existing_public_method
    assert_allows_stubbing_existing_method(:public)
  end

  def test_should_allow_stubbing_existing_protected_method
    assert_allows_stubbing_existing_method(:protected)
  end

  def test_should_allow_stubbing_existing_private_method
    assert_allows_stubbing_existing_method(:private)
  end

  def test_should_allow_stubbing_method_responded_to
    method_owner.send(:define_method, :respond_to?) do |method|
      (method == :method_responded_to)
    end
    assert_allows_stubbing_method(:method_responded_to)
  end

  def assert_allows_stubbing_existing_method(visibility)
    method_owner.send(:define_method, :existing_method) {}
    method_owner.send(visibility, :existing_method)
    assert_allows_stubbing_method(:existing_method)
  end

  def assert_allows_stubbing_method(stubbed_method)
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    stub_owner_in_scope = stub_owner
    test_result = run_as_test do
      stub_owner_in_scope.stubs(stubbed_method)
    end
    assert_passed(test_result)
  end
end
