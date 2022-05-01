require File.expand_path('../stubbing_with_potential_violation_is_checked', __FILE__)

class StubbingMethodUnnecessarilyTest < Mocha::TestCase
  include StubbingWithPotentialViolationIsCheckedAndAllowedByDefault

  def configure_violation(config, treatment)
    config.stubbing_method_unnecessarily = treatment
  end

  def potential_violation
    mock = mock('mock')
    mock.stubs(:public_method)
  end

  def message_on_violation
    'stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)'
  end

  def test_should_allow_stubbing_method_when_stubbed_method_is_invoked
    test_result = run_test_with_check(:prevent) do
      mock = mock('mock')
      mock.stubs(:public_method)
      mock.public_method
    end
    assert_passed(test_result)
  end
end
