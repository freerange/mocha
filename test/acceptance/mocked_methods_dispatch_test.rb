require File.expand_path('../acceptance_test_helper', __FILE__)
require 'deprecation_disabler'
require 'execution_point'

class MockedMethodDispatchTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_find_latest_matching_expectation
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 2, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_find_latest_expectation_which_has_not_stopped_matching
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.stubs(:method).once.returns(2)
      assert_equal 2, mock.method
      assert_equal 1, mock.method
      assert_equal 1, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_keep_finding_later_stub_and_so_never_satisfy_earlier_expectation
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 2, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
    end
    assert_failed(test_result)
  end

  def test_should_find_later_expectation_until_it_stops_matching_then_find_earlier_stub
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.expects(:method).returns(2)
      assert_equal 2, mock.method
      assert_equal 1, mock.method
      assert_equal 1, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_find_latest_expectation_with_range_of_expected_invocation_count_which_has_not_stopped_matching
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.stubs(:method).times(2..3).returns(2)
      assert_equal 2, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
      assert_equal 1, mock.method
      assert_equal 1, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_display_deprecation_warning_if_invocation_matches_expectation_with_never_cardinality
    execution_point = nil
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:method)
      mock.expects(:method).never; execution_point = ExecutionPoint.current
      DeprecationDisabler.disable_deprecations do
        mock.method
      end
    end
    assert_passed(test_result)
    message = Mocha::Deprecation.messages.last
    location = execution_point.location
    expected = [
      "The expectation defined at #{location} does not allow invocations, but #<Mock:mock>.method() was invoked.",
      'This invocation will cause the test to fail fast in a future version of Mocha.'
    ]
    assert_equal expected.join(' '), message
  end
end
