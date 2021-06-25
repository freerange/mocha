require File.expand_path('../stubbing_with_potential_violation_is_checked', __FILE__)

module StubbingNonExistentMethodIsChecked
  include StubbingWithPotentialViolationIsCheckedAndAllowedByDefault

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    stubbee.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{stubbee.mocha_inspect}.non_existent_method"
  end
end
