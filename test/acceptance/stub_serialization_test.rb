require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'
require 'yaml'

class StubSerializationTest < Mocha::TestCase

  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_serialize_and_unserialize_successfully
    test_result = run_as_test do
      before = mock('before')
      before.stubs(:bar).returns('bar')
      dump = YAML.dump(before)
      after = YAML.load(dump)
      assert_equal 'bar', after.bar
    end
    assert_passed(test_result)
  end
end
