require File.expand_path('../acceptance_test_helper', __FILE__)

class SequenceBlockTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_constrain_invocations_to_occur_in_expected_order
    test_result = run_as_test do
      mock = mock()

      sequence('one') do
        mock.expects(:first)
        mock.expects(:second)
      end

      mock.second
      mock.first
    end
    assert_failed(test_result)
    assert_match 'second() invoked out of order', test_result.failures.first.message
  end

  def test_should_allow_invocations_in_sequence
    test_result = run_as_test do
      mock = mock()

      sequence('one') do
        mock.expects(:first)
        mock.expects(:second)
      end

      mock.first
      mock.second
    end
    assert_passed(test_result)
  end

  def test_should_constrain_invocations_to_occur_in_expected_order_even_if_expected_on_different_mocks
    test_result = run_as_test do
      mock_one = mock('1')
      mock_two = mock('2')

      sequence('one') do
        mock_one.expects(:first)
        mock_two.expects(:second)
      end

      mock_two.second
      mock_one.first
    end
    assert_failed(test_result)
  end

  def test_should_allow_invocations_in_sequence_even_if_expected_on_different_mocks
    test_result = run_as_test do
      mock_one = mock('1')
      mock_two = mock('2')

      sequence('one') do
        mock_one.expects(:first)
        mock_two.expects(:second)
      end

      mock_one.first
      mock_two.second
    end
    assert_passed(test_result)
  end

  def test_should_constrain_invocations_to_occur_in_expected_order_even_if_expected_on_partial_mocks
    test_result = run_as_test do
      partial_mock_one = Object.new
      partial_mock_two = Object.new

      sequence('one') do
        partial_mock_one.expects(:first)
        partial_mock_two.expects(:second)
      end

      partial_mock_two.second
      partial_mock_one.first
    end
    assert_failed(test_result)
    assert_match 'second() invoked out of order', test_result.failures.first.message
  end

  def test_should_allow_invocations_in_sequence_even_if_expected_on_partial_mocks
    test_result = run_as_test do
      partial_mock_one = Object.new
      partial_mock_two = Object.new

      sequence('one') do
        partial_mock_one.expects(:first)
        partial_mock_two.expects(:second)
      end

      partial_mock_one.first
      partial_mock_two.second
    end
    assert_passed(test_result)
  end

  def test_should_allow_stub_expectations_to_be_skipped_in_sequence
    test_result = run_as_test do
      mock = mock()

      sequence('one') do
        mock.expects(:first)
        mock.stubs(:second)
        mock.expects(:third)
      end

      mock.first
      mock.third
    end
    assert_passed(test_result)
  end

  def test_should_regard_nested_sequences_as_independent_of_each_other
    test_result = run_as_test do
      mock = mock()

      sequence('one') do
        mock.expects(:first)
        mock.expects(:second)

        sequence('two') do
          mock.expects(:third)
          mock.expects(:fourth)
        end
      end

      mock.first
      mock.third
      mock.second
      mock.fourth
    end
    assert_passed(test_result)
  end

  def test_should_include_sequence_in_failure_message
    test_result = run_as_test do
      mock = mock()

      sequence('one') do
        mock.expects(:first)
        mock.expects(:second)
      end

      mock.second
      mock.first
    end
    assert_failed(test_result)
    assert_match Regexp.new(%(in sequence "one")), test_result.failures.first.message
  end

  def test_should_allow_expectations_to_be_in_more_than_one_sequence
    test_result = run_as_test do
      mock = mock()
      sequence_one = sequence('one')

      mock.expects(:first).in_sequence(sequence_one)

      sequence('two') do
        mock.expects(:second)
        mock.expects(:third).in_sequence(sequence_one)
      end

      mock.first
      mock.third
      mock.second
    end
    assert_failed(test_result)
    assert_match Regexp.new(%(in sequence "one")), test_result.failures.first.message
    assert_match Regexp.new(%(in sequence "two")), test_result.failures.first.message
  end
end
