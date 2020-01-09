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

  def test_should_allow_stubbing_method_unnecessarily
    test_result = stub_method_unnecessarily(:allow)
    assert_passed(test_result)
    assert !@logger.warnings.include?(violation_message)
  end

  def test_should_warn_when_stubbing_method_unnecessarily
    test_result = stub_method_unnecessarily(:warn)
    assert_passed(test_result)
    assert @logger.warnings.include?(violation_message)
  end

  def test_should_prevent_stubbing_method_unnecessarily
    test_result = stub_method_unnecessarily(:prevent)
    assert_failed(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: #{violation_message}")
  end

  def test_should_default_to_allow_stubbing_method_unnecessarily
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?(violation_message)
  end

  def test_should_allow_stubbing_method_when_stubbed_method_is_invoked
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :prevent }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
      mock.public_method
    end
    assert_passed(test_result)
  end

  def stub_method_unnecessarily(treatment)
    Mocha.configure { |c| c.stubbing_method_unnecessarily = treatment }
    run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
  end

  def violation_message
    'stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)'
  end
end
