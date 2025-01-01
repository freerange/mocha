require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/ruby_version'

class PositionalAndKeywordHashInspectTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_single_hash_parameters_in_invocation_and_expectation_print_correctly
    test_result = run_as_test do
      mock = mock('mock')
      mock.expects(:method).with({ foo: 42 })
      mock.method({ key: 42 })
    end
    assert_equal [
      'unexpected invocation: #<Mock:mock>.method({:key => 42})',
      'unsatisfied expectations:',
      '- expected exactly once, invoked never: #<Mock:mock>.method({:foo => 42})'
    ], test_result.failure_message_lines
  end

  def test_unexpected_keyword_arguments_in_invocation_and_expectation_print_correctly
    test_result = run_as_test do
      mock = mock('mock')
      mock.expects(:method).with(foo: 42)
      mock.method(key: 42)
    end
    if Mocha::RUBY_V27_PLUS
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(key: 42)',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(foo: 42)'
      ], test_result.failure_message_lines
    else
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method({:key => 42})',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method({:foo => 42})'
      ], test_result.failure_message_lines
    end
  end

  def test_last_hash_parameters_in_invocation_and_expectation_print_correctly
    test_result = run_as_test do
      mock = mock('mock')
      mock.expects(:method).with(1, { foo: 42 })
      mock.method(1, { key: 42 })
    end
    assert_equal [
      'unexpected invocation: #<Mock:mock>.method(1, {:key => 42})',
      'unsatisfied expectations:',
      '- expected exactly once, invoked never: #<Mock:mock>.method(1, {:foo => 42})'
    ], test_result.failure_message_lines
  end

  def test_unexpected_keyword_arguments_with_other_positionals_in_invocation_and_expectation_print_correctly
    test_result = run_as_test do
      mock = mock('mock')
      mock.expects(:method).with(1, foo: 42)
      mock.method(1, key: 42)
    end
    if Mocha::RUBY_V27_PLUS
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(1, key: 42)',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(1, foo: 42)'
      ], test_result.failure_message_lines
    else
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(1, {:key => 42})',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(1, {:foo => 42})'
      ], test_result.failure_message_lines
    end
  end

  if Mocha::RUBY_V27_PLUS
    def test_single_hash_parameters_in_invocation_and_expectation_print_correctly_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock('mock')
        mock.expects(:method).with({ foo: 42 })
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method({ key: 42 })
        end
      end
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method({:key => 42})',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method({:foo => 42})'
      ], test_result.failure_message_lines
    end

    def test_unexpected_keyword_arguments_in_invocation_and_expectation_print_correctly_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock('mock')
        mock.expects(:method).with(foo: 42)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method(key: 42)
        end
      end
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(key: 42)',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(foo: 42)'
      ], test_result.failure_message_lines
    end

    def test_last_hash_parameters_in_invocation_and_expectation_print_correctly_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock('mock')
        mock.expects(:method).with(1, { foo: 42 })
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method(1, { key: 42 })
        end
      end
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(1, {:key => 42})',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(1, {:foo => 42})'
      ], test_result.failure_message_lines
    end

    def test_unexpected_keyword_arguments_with_other_positionals_in_invocation_and_expectation_print_correctly_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock('mock')
        mock.expects(:method).with(1, foo: 42)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method(1, key: 42)
        end
      end
      assert_equal [
        'unexpected invocation: #<Mock:mock>.method(1, key: 42)',
        'unsatisfied expectations:',
        '- expected exactly once, invoked never: #<Mock:mock>.method(1, foo: 42)'
      ], test_result.failure_message_lines
    end
  end
end
