# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class MockTest < Mocha::TestCase
  include AcceptanceTestHelper
  include Mocha

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

  def test_should_build_string_named_mock_and_explicitly_add_an_expectation_which_is_satisfied
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar)
      foo.bar
    end
    assert_passed(test_result)
  end

  def test_should_build_symbol_named_mock_and_explicitly_add_an_expectation_which_is_satisfied
    test_result = run_as_test do
      foo = mock(:foo)
      foo.expects(:bar)
      foo.bar
    end
    assert_passed(test_result)
  end

  def test_should_build_string_named_mock_and_explicitly_add_an_expectation_which_is_not_satisfied
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar)
    end
    assert_failed(test_result)
  end

  def test_should_build_symbol_named_mock_and_explicitly_add_an_expectation_which_is_not_satisfied
    test_result = run_as_test do
      foo = mock(:foo)
      foo.expects(:bar)
    end
    assert_failed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock(bar: 'bar', baz: 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(bar: 'bar', baz: 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(bar: 'bar', baz: 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end

  def test_should_build_string_named_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock('foo', bar: 'bar', baz: 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock(:foo, bar: 'bar', baz: 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_string_named_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', bar: 'bar', baz: 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(:foo, bar: 'bar', baz: 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_string_named_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', bar: 'bar', baz: 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock(:foo, bar: 'bar', baz: 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end

  class Foo
    class << self
      attr_accessor :bar
    end

    def use_the_mock
      self.class.bar.baz('Foo was here')
    end
  end

  def test_should_raise_stubbing_error_if_mock_receives_invocations_in_another_test
    use_mock_test_result = run_as_test do
      Foo.bar = mock('Bar')
      Foo.bar.expects(:baz).with('Foo was here')
      Foo.new.use_the_mock
    end
    assert_passed(use_mock_test_result)

    reuse_mock_test_result = run_as_test do
      Foo.bar.expects(:baz).with('Foo was here')
      e = assert_raises(Mocha::StubbingError) { Foo.new.use_the_mock }
      assert e.message.include?('#<Mock:Bar> was instantiated in FakeTest#test_me but it is receiving invocations within another test.')
      assert e.message.include?('This can lead to unintended interactions between tests and hence unexpected test failures.')
      assert e.message.include?('Ensure that every test correctly cleans up any state that it introduces.')
    end
    assert_passed(reuse_mock_test_result)
  end
end
