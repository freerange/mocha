require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingMethodUnnecessarilyTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_with_potential_violation
    assert_passed(stub_with_potential_violation(:allow))
    assert !@logger.warnings.include?(violation_message)
  end

  def test_should_warn_on_stubbing_with_potential_violation
    assert_passed(stub_with_potential_violation(:warn))
    assert @logger.warnings.include?(violation_message)
  end

  def test_should_prevent_stubbing_with_potential_violation
    test_result = stub_with_potential_violation(:prevent)
    assert_failed(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: #{violation_message}")
  end

  def test_should_default_to_allow_stubbing_method_unnecessarily
    assert_passed(stub_with_potential_violation)
    assert !@logger.warnings.include?(violation_message)
  end

  def test_should_allow_stubbing_method_when_stubbed_method_is_invoked
    test_result = run_test_with_check(:prevent) do
      mock = mock('mock')
      mock.stubs(:public_method)
      mock.public_method
    end
    assert_passed(test_result)
  end

  def stub_with_potential_violation(treatment = :default)
    run_test_with_check(treatment) do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
  end

  def run_test_with_check(treatment = :default, &block)
    Mocha.configure { |c| c.stubbing_method_unnecessarily = treatment } unless treatment == :default
    run_as_test(&block)
  end

  def violation_message
    'stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)'
  end
end
