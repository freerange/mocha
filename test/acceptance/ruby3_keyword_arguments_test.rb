require File.expand_path('../acceptance_test_helper', __FILE__)

class KeywordArgumentsTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  # somewhat adapted from https://github.com/ruby/ruby/blob/4643bf5d55af6f79266dd67b69bb6eb4ff82029a/doc/NEWS-2.7.0#the-spec-of-keyword-arguments-is-changed-towards-30-

  # previously failing
  def test_should_not_match_hash_parameter_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42)
      mock.method({ key: 42 })
    end
    assert_failed(test_result)
  end

  # previously failing
  def test_should_not_match_hash_parameter_with_splatted_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ key: 42 })
      mock.method({ key: 42 })
    end
    assert_failed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42)
      mock.method(**{ key: 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_splatted_hash
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ key: 42 })
      mock.method(**{ key: 42 })
    end
    assert_passed(test_result)
  end

  # previously failing
  def test_should_not_match_keyword_args_with_positional_hash
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { key: 42 })
      mock.method(1, key: 42)
    end
    assert_failed(test_result)
  end

  # previously failing
  def test_should_not_match_positional_hash_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42)
      mock.method(1, { key: 42 })
    end
    assert_failed(test_result)
  end

  def test_should_match_keyword_args_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42)
      mock.method(1, key: 42)
    end
    assert_passed(test_result)
  end
end
