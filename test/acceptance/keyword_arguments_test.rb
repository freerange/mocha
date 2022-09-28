require File.expand_path('../acceptance_test_helper', __FILE__)

class KeywordArgumentsTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_hash_parameter_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(:key => 42)
      mock.method({ :key => 42 })
    end
    assert_passed(test_result)
    # with strict keyword matching:
    # assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_splatted_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ :key => 42 })
      mock.method({ :key => 42 })
    end
    assert_passed(test_result)
    # with strict keyword matching:
    # assert_failed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(:key => 42)
      mock.method(**{ :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_splatted_hash
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ :key => 42 })
      mock.method(**{ :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_last_positional_hash
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { :key => 42 })
      mock.method(1, :key => 42)
    end
    assert_passed(test_result)
    # with strict keyword matching:
    # assert_failed(test_result)
  end

  def test_should_match_last_positional_hash_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, :key => 42)
      mock.method(1, { :key => 42 })
    end
    assert_passed(test_result)
    # with strict keyword matching:
    # assert_failed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, :key => 42)
      mock.method(1, :key => 42)
    end
    assert_passed(test_result)
  end

  def test_should_match_hash_parameter_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key))
      mock.method({ :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key))
      mock.method(**{ :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, has_key(:key))
      mock.method(1, :key => 42)
    end
    assert_passed(test_result)
  end

  def test_should_match_last_positional_hash_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, has_key(:key))
      mock.method(1, { :key => 42 })
    end
    assert_passed(test_result)
  end
end
