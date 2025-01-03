# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingOnNonMockObjectTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_method_on_non_mock_object
    Mocha.configure { |c| c.stubbing_method_on_non_mock_object = :allow }
    non_mock_object = Class.new do
      def existing_method; end
    end
    test_result = run_as_test do
      non_mock_object.stubs(:existing_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing method on non-mock object: #{non_mock_object.mocha_inspect}.existing_method")
  end

  def test_should_warn_on_stubbing_method_on_non_mock_object
    Mocha.configure { |c| c.stubbing_method_on_non_mock_object = :warn }
    non_mock_object = Class.new do
      def existing_method; end
    end
    test_result = run_as_test do
      non_mock_object.stubs(:existing_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing method on non-mock object: #{non_mock_object.mocha_inspect}.existing_method")
  end

  def test_should_prevent_stubbing_method_on_non_mock_object
    Mocha.configure { |c| c.stubbing_method_on_non_mock_object = :prevent }
    non_mock_object = Class.new do
      def existing_method; end
    end
    test_result = run_as_test do
      non_mock_object.stubs(:existing_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing method on non-mock object: #{non_mock_object.mocha_inspect}.existing_method")
  end

  def test_should_default_to_allow_stubbing_method_on_non_mock_object
    non_mock_object = Class.new do
      def existing_method; end
    end
    test_result = run_as_test do
      non_mock_object.stubs(:existing_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing method on non-mock object: #{non_mock_object.mocha_inspect}.existing_method")
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
