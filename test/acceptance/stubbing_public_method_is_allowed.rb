require File.expand_path('../acceptance_test_helper', __FILE__)

module StubbingPublicMethodIsAllowed
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_public_method
    method_owner.send(:define_method, :public_method) {}
    method_owner.send(:public, :public_method)
    assert_allows_stubbing_method(:public_method)
  end

  def test_should_allow_stubbing_method_responded_to
    method_owner.send(:define_method, :respond_to?) do |method|
      (method == :method_responded_to)
    end
    assert_allows_stubbing_method(:method_responded_to)
  end

  def assert_allows_stubbing_method(stubbed_method)
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    stub_owner_in_scope = stub_owner
    test_result = run_as_test do
      stub_owner_in_scope.stubs(stubbed_method)
    end
    assert_passed(test_result)
  end
end
