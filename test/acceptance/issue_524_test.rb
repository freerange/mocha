require File.expand_path('../acceptance_test_helper', __FILE__)

class Issue524Test < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_expects_returns_last_expectation
    test_result = run_as_test do
      object = mock
      object.expects(method_1: 1, method_2: 2).twice
      object.method_1
      object.method_2
      object.method_2
    end
    assert_passed(test_result)
  end

  def test_stubs_returns_last_expectation
    test_result = run_as_test do
      object = mock
      object.stubs(method_1: 1, method_2: 2).twice
      object.method_1
      object.method_2
      object.method_2
    end
    assert_passed(test_result)
  end
end
