# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class StubEnvTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_stub_method_on_env_within_test
    test_result = run_as_test do
      ENV.stubs(:key?).with('MOCHA_STUBBED').returns(true)
      assert ENV.key?('MOCHA_STUBBED')
    end
    assert_passed(test_result)
    assert_equal false, ENV.key?('MOCHA_STUBBED')
  end

  def test_should_fail_if_expected_method_on_env_is_not_called
    test_result = run_as_test do
      ENV.expects(:fetch).with('MOCHA_EXPECTED')
    end
    assert_failed(test_result)
  end

  def test_should_unstub_method_on_env
    test_result = run_as_test do
      ENV.stubs(:key?).returns(true)
      ENV.unstub(:key?)
      assert_equal false, ENV.key?('MOCHA_UNSTUBBED')
    end
    assert_passed(test_result)
  end
end
