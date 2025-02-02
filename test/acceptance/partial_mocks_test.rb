# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class PartialMocksTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_pass_if_all_expectations_are_satisfied
    test_result = run_as_test do
      partial_mock_one = Object.new
      partial_mock_two = Object.new

      partial_mock_one.expects(:first)
      partial_mock_one.expects(:second)
      partial_mock_two.expects(:third)

      partial_mock_one.first
      partial_mock_one.second
      partial_mock_two.third
    end
    assert_passed(test_result)
  end

  def test_should_fail_if_all_expectations_are_not_satisfied
    test_result = run_as_test do
      partial_mock_one = Object.new
      partial_mock_two = Object.new

      partial_mock_one.expects(:first)
      partial_mock_one.expects(:second)
      partial_mock_two.expects(:third)

      partial_mock_one.first
      partial_mock_two.third
    end
    assert_failed(test_result)
  end
end
