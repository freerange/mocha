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
  end

  def test_should_not_match_hash_parameter_with_keyword_args_when_strict_keyword_matching_is_enabled
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(:key => 42)
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        mock.method({ :key => 42 })
      end
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_splatted_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ :key => 42 })
      mock.method({ :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_not_should_match_hash_parameter_with_splatted_keyword_args_when_strict_keyword_matching_is_enabled
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(**{ :key => 42 })
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        mock.method({ :key => 42 })
      end
    end
    assert_failed(test_result)
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
  end

  def test_should_not_match_positional_and_keyword_args_with_last_positional_hash_when_strict_keyword_args_is_enabled
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { :key => 42 })
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        mock.method(1, :key => 42)
      end
    end
    assert_failed(test_result)
  end

  def test_should_match_last_positional_hash_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, :key => 42)
      mock.method(1, { :key => 42 })
    end
    assert_passed(test_result)
  end

  def test_should_not_match_last_positional_hash_with_keyword_args_when_strict_keyword_args_is_enabled
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, :key => 42)
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        mock.method(1, { :key => 42 })
      end
    end
    assert_failed(test_result)
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
