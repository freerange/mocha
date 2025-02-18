# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'execution_point'

class StubbaTestResultTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_include_expectation_verification_in_assertion_count
    test_result = run_as_test do
      object = Class.new do
        def message; end
      end.new
      object.expects(:message)
      object.message
    end
    assert_equal 1, test_result.assertion_count
  end

  def test_should_include_assertions_in_assertion_count
    test_result = run_as_test do
      assert true
    end
    assert_equal 1, test_result.assertion_count
  end

  def test_should_not_include_stubbing_expectation_verification_in_assertion_count
    test_result = run_as_test do
      object = Class.new do
        def message; end
      end.new
      object.stubs(:message)
      object.message
    end
    assert_equal 0, test_result.assertion_count
  end

  def test_should_include_expectation_verification_failure_in_failure_count
    test_result = run_as_test do
      object = Class.new do
        def message; end
      end.new
      object.expects(:message)
    end
    assert_equal 1, test_result.failure_count
  end

  def test_should_include_assertion_failure_in_failure_count
    test_result = run_as_test do
      flunk
    end
    assert_equal 1, test_result.failure_count
  end

  def test_should_display_backtrace_indicating_line_number_where_failing_assertion_was_called
    execution_point = nil
    test_result = run_as_test do
      execution_point = ExecutionPoint.current; flunk
    end
    assert_equal 1, test_result.failure_count
    assert_equal execution_point, ExecutionPoint.new(test_result.failures[0].location)
  end
end
