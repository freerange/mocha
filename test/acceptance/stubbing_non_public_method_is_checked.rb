require File.expand_path('../stubbing_with_potential_violation_is_checked', __FILE__)

module StubbingNonPublicMethodIsChecked
  include StubbingWithPotentialViolationIsCheckedAndAllowedByDefault

  def setup
    super
    method_owner.send(:define_method, :non_public_method) {}
    method_owner.send(visibility, :non_public_method)
  end

  def configure_violation(config, treatment)
    config.stubbing_non_public_method = treatment
  end

  def potential_violation
    stubbee.stubs(:non_public_method)
  end

  def message_on_violation
    "stubbing non-public method: #{stubbee.mocha_inspect}.non_public_method"
  end
end
