require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

module StubbingNonExistentMethodSharedTests
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    stub_owner.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{stub_owner.mocha_inspect}.non_existent_method"
  end
end
