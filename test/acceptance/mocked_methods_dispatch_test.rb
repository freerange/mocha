require File.expand_path('../acceptance_test_helper', __FILE__)

class MockedMethodDispatchTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_find_oldest_matching_expectation
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 1, mock.method
      assert_equal 1, mock.method
      assert_equal 1, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_find_oldest_expectation_which_has_not_stopped_matching
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).once.returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 1, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_keep_finding_older_stub_and_so_never_satisfy_earlier_expectation
    responses = []
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).returns(1)
      mock.expects(:method).returns(2)
      3.times { responses << mock.method }
    end
    assert_equal [1, 1, 1], responses
    assert_failed(test_result)
  end

  def test_should_find_older_expectation_until_it_stops_matching_then_find_earlier_stub
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 1, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
    end
    assert_passed(test_result)
  end

  def test_should_find_oldest_expectation_with_range_of_expected_invocation_count_which_has_not_stopped_matching
    test_result = run_as_test do
      mock = mock()
      mock.stubs(:method).times(2..3).returns(1)
      mock.stubs(:method).returns(2)
      assert_equal 1, mock.method
      assert_equal 1, mock.method
      assert_equal 1, mock.method
      assert_equal 2, mock.method
      assert_equal 2, mock.method
    end
    assert_passed(test_result)
  end
end
