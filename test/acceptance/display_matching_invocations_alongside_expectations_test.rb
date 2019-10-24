require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class DisplayMatchingInvocationsAlongsideExpectationsTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
    @original_env = ENV.to_hash
    ENV['MOCHA_OPTIONS'] = 'verbose'
  end

  def teardown
    ENV.replace(@original_env)
    teardown_acceptance_test
  end

  def test_should_display_results
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar).with(1).returns('a')
      foo.stubs(:bar).with(any_parameters).returns('f').raises(StandardError)

      foo.bar(1, 2) { |_ignored| }
      assert_raise(StandardError) { foo.bar(3, 4) { |_ignored| } }
    end
    assert_invocations(
      test_result,
      '- allowed any number of times, invoked twice: #<Mock:foo>.bar(any_parameters)',
      '  - #<Mock:foo>.bar(1, 2) # => "f"',
      '  - #<Mock:foo>.bar(3, 4) # => raised StandardError'
    )
  end

  def test_should_display_yields
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar).with(1).returns('a')
      foo.stubs(:bar).with(any_parameters).multiple_yields(%w[b c], %w[d e]).returns('f').raises(StandardError)

      foo.bar(1, 2) { |_ignored| }
      assert_raise(StandardError) { foo.bar(3, 4) { |_ignored| } }
    end
    assert_invocations(
      test_result,
      '- allowed any number of times, invoked twice: #<Mock:foo>.bar(any_parameters)',
      '  - #<Mock:foo>.bar(1, 2) # => "f" after yielding ("b", "c"), then ("d", "e")',
      '  - #<Mock:foo>.bar(3, 4) # => raised StandardError after yielding ("b", "c"), then ("d", "e")'
    )
  end

  def test_should_display_empty_yield_and_return
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar).with(1).returns('a')
      foo.stubs(:bar).with(any_parameters).yields

      foo.bar(1, 2) { |_ignored| }
    end
    assert_invocations(
      test_result,
      '- allowed any number of times, invoked once: #<Mock:foo>.bar(any_parameters)',
      '  - #<Mock:foo>.bar(1, 2) # => nil after yielding ()'
    )
  end

  def assert_invocations(test_result, *invocations)
    assert_failed(test_result)
    assert_equal [
      'not all expectations were satisfied',
      'unsatisfied expectations:',
      '- expected exactly once, not yet invoked: #<Mock:foo>.bar(1)',
      'satisfied expectations:',
      *invocations
    ], test_result.failure_message_lines
  end
end
