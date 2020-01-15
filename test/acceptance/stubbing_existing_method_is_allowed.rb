require File.expand_path('../stubbing_public_method_is_allowed', __FILE__)

module StubbingExistingMethodIsAllowed
  include StubbingPublicMethodIsAllowed

  def test_should_allow_stubbing_existing_protected_method
    assert_allows_stubbing_existing_method(:protected)
  end

  def test_should_allow_stubbing_existing_private_method
    assert_allows_stubbing_existing_method(:private)
  end

  def assert_allows_stubbing_existing_method(visibility)
    method_owner.send(:define_method, :existing_method) {}
    method_owner.send(visibility, :existing_method)
    assert_allows_stubbing_method(:existing_method)
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end
end
