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

  def test_should_display_return_values_of_matching_invocations
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar).with(1).returns('a')
      foo.stubs(:bar).with(2).returns('b').then.returns('c')

      2.times { foo.bar(2) }
      foo.bar(3)
    end
    assert_failed(test_result)
    assert_equal [
      'unexpected invocation: #<Mock:foo>.bar(3)',
      'unsatisfied expectations:',
      '- expected exactly once, not yet invoked: #<Mock:foo>.bar(1)',
      'satisfied expectations:',
      '- allowed any number of times, invoked twice: #<Mock:foo>.bar(2)',
      '  - #<Mock:foo>.bar(2) # => "b"',
      '  - #<Mock:foo>.bar(2) # => "c"'
    ], test_result.failure_message_lines
  end
end
