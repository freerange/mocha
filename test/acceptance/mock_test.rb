require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class MockTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_build_mock_and_explicitly_add_an_expectation_which_is_satisfied
    test_result = run_as_test do
      foo = mock
      foo.expects(:bar)
      foo.bar
    end
    assert_passed(test_result)
  end

  def test_should_build_mock_and_explicitly_add_an_expectation_which_is_not_satisfied
    test_result = run_as_test do
      foo = mock
      foo.expects(:bar)
    end
    assert_failed(test_result)
  end

  def test_should_build_named_mock_and_explicitly_add_an_expectation_which_is_satisfied
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar)
      foo.bar
    end
    assert_passed(test_result)
  end

  def test_should_build_named_mock_and_explicitly_add_an_expectation_which_is_not_satisfied
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar)
    end
    assert_failed(test_result)
  end

  def test_build_mock_with_method_name_symbol_which_is_satisfied
    test_result = run_as_test do
      foo = mock(:cat)
      foo.cat
    end
    assert_passed(test_result)
  end

  def test_build_mock_with_method_name_symbol_which_is_not_satisfied
    test_result = run_as_test do
      mock(:cat)
    end
    assert_failed(test_result)
  end

  def test_build_mock_with_method_name_symbol_which_is_called_twice
    test_result = run_as_test do
      foo = mock(:cat)
      foo.cat
      foo.cat
    end
    assert_failed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock(:bar => 'bar', :baz => 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(:bar => 'bar', :baz => 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(:bar => 'bar', :baz => 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end

  def test_should_build_named_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_named_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_named_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end
end
