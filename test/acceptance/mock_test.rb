require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'
require 'mocha/deprecation'
require 'deprecation_disabler'

class MockTest < Mocha::TestCase
  include AcceptanceTest
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
      Mocha::Configuration.override(:reinstate_undocumented_behaviour_from_v1_9 => false) do
        DeprecationDisabler.disable_deprecations do
          foo = mock(:foo)
          foo.expects(:bar)
          foo.bar
        end
      end
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
      DeprecationDisabler.disable_deprecations do
        foo = mock(:foo)
        foo.expects(:bar)
      end
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

  def test_should_build_string_named_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.bar
      foo.baz
    end
    assert_passed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_which_are_satisifed
    test_result = run_as_test do
      Mocha::Configuration.override(:reinstate_undocumented_behaviour_from_v1_9 => false) do
        DeprecationDisabler.disable_deprecations do
          foo = mock(:foo, :bar => 'bar', :baz => 'baz')
          foo.bar
          foo.baz
        end
      end
    end
    assert_passed(test_result)
  end

  def test_should_build_string_named_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.baz
    end
    assert_failed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_the_first_of_which_is_not_satisifed
    test_result = run_as_test do
      DeprecationDisabler.disable_deprecations do
        foo = mock(:foo, :bar => 'bar', :baz => 'baz')
        foo.baz
      end
    end
    assert_failed(test_result)
  end

  def test_should_build_string_named_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      foo = mock('foo', :bar => 'bar', :baz => 'baz')
      foo.bar
    end
    assert_failed(test_result)
  end

  def test_should_build_symbol_named_mock_incorporating_two_expectations_the_second_of_which_is_not_satisifed
    test_result = run_as_test do
      DeprecationDisabler.disable_deprecations do
        foo = mock(:foo, :bar => 'bar', :baz => 'baz')
        foo.bar
      end
    end
    assert_failed(test_result)
  end

  class Foo
    class << self
      attr_accessor :logger
    end

    def use_the_mock
      self.class.logger.log('Foo was here')
    end
  end

  def test_should_not_allow_mock_to_be_reused_in_another_test
    use_mock_test_result = run_as_test do
      Foo.logger = mock('Logger')
      Foo.logger.expects(:log).with('Foo was here')
      Foo.new.use_the_mock
    end
    assert_passed(use_mock_test_result)

    reuse_mock_test_result = run_as_test do
      DeprecationDisabler.disable_deprecations do
        Foo.logger.expects(:log).with('Foo was here')
        Foo.new.use_the_mock
      end
    end
    assert_passed(reuse_mock_test_result)
    expected_warning = '#<Mock:Logger> was originally created in one test but has leaked into another test. '\
      'This can lead to flaky tests. Ensure that your tests correctly clean up their state after themselves. '\
      'This will raise a Mocha::StubbingError in the future.'
    assert_equal expected_warning, Deprecation.messages.last
  end
end
