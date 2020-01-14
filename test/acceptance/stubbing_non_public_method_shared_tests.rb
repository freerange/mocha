require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

module StubbingNonPublicMethodSharedTests
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    method_owner.send(:define_method, :non_public_method) {}
    method_owner.send(visibility, :non_public_method)
  end

  def configure_violation(config, treatment)
    config.stubbing_non_public_method = treatment
  end

  def potential_violation
    stub_owner.stubs(:non_public_method)
  end

  def message_on_violation
    "stubbing non-public method: #{stub_owner.mocha_inspect}.non_public_method"
  end
end
