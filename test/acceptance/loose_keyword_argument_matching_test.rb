# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

require 'execution_point'
require 'mocha/ruby_version'
require 'mocha/configuration'

class LooseKeywordArgumentMatchingTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
    Mocha.configure { |c| c.strict_keyword_argument_matching = false } if Mocha::RUBY_V27_PLUS
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_hash_parameter_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42); execution_point = ExecutionPoint.current
      mock.method({ key: 42 })
    end
    assert_passed(test_result)
    return unless Mocha::RUBY_V27_PLUS

    assert_deprecation_warning_location(execution_point)
    assert_deprecation_warning(
      'expected keyword arguments (key: 42), but received positional hash ({key: 42})'
    )
  end

  def test_should_match_hash_parameter_with_splatted_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      kwargs = { key: 42 }
      mock.expects(:method).with(**kwargs); execution_point = ExecutionPoint.current
      mock.method({ key: 42 })
    end
    assert_passed(test_result)
    return unless Mocha::RUBY_V27_PLUS

    assert_deprecation_warning_location(execution_point)
    assert_deprecation_warning(
      'expected keyword arguments (key: 42), but received positional hash ({key: 42})'
    )
  end

  def test_should_match_positional_and_keyword_args_with_last_positional_hash
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { key: 42 })
      mock.method(1, key: 42)
    end
    assert_passed(test_result)
    return unless Mocha::RUBY_V27_PLUS

    assert_no_deprecation_warning
  end

  def test_should_match_last_positional_hash_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42); execution_point = ExecutionPoint.current
      mock.method(1, { key: 42 })
    end
    assert_passed(test_result)
    return unless Mocha::RUBY_V27_PLUS

    assert_deprecation_warning_location(execution_point)
    assert_deprecation_warning(
      'expected keyword arguments (key: 42), but received positional hash ({key: 42})'
    )
  end

  private

  def assert_deprecation_warning(expected_warning)
    assert_includes logger.warnings.last, expected_warning
  end

  def assert_no_deprecation_warning
    warning = logger.warnings.last
    assert_nil warning, "Unexpected deprecation warning: #{warning}"
  end

  def assert_deprecation_warning_location(execution_point)
    expected_location = "Expectation defined at #{execution_point.location}"
    assert_deprecation_warning expected_location
  end
end
