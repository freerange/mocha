require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

module StubbingWithPotentialViolationSharedTests
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_with_potential_violation
    assert_passed(stub_with_potential_violation(:allow))
    assert !@logger.warnings.include?(message_on_violation)
  end

  def test_should_warn_on_stubbing_with_potential_violation
    assert_passed(stub_with_potential_violation(:warn))
    assert @logger.warnings.include?(message_on_violation)
  end

  def test_should_prevent_stubbing_with_potential_violation
    test_result = stub_with_potential_violation(:prevent)
    assert_failed(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: #{message_on_violation}")
  end

  def stub_with_potential_violation(treatment = :default)
    run_test_with_check(treatment, &method(:potential_violation))
  end

  def run_test_with_check(treatment = :default, &block)
    Mocha.configure { |c| configure_violation(c, treatment) } unless treatment == :default
    run_as_test(&block)
  end
end
