require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

class StubbingOnNonMockObjectTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @non_mock_object = Class.new do
      def existing_method; end
    end
  end

  def configure_violation(config, treatment)
    config.stubbing_method_on_non_mock_object = treatment
  end

  def potential_violation
    @non_mock_object.stubs(:existing_method)
  end

  def message_on_violation
    "stubbing method on non-mock object: #{@non_mock_object.mocha_inspect}.existing_method"
  end

  def test_should_allow_stubbing_method_on_mock_object
    Mocha.configure { |c| c.stubbing_method_on_non_mock_object = :prevent }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:any_method)
    end
    assert_passed(test_result)
  end
end
