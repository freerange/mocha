# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/ruby_version'

class FailureMessagesTest < Mocha::TestCase
  OBJECT_ADDRESS_PATTERN = '0x[0-9A-Fa-f]{1,12}'

  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  class Foo; end

  def test_should_display_class_name_when_expectation_was_on_class
    test_result = run_as_test do
      Foo.expects(:bar)
    end
    assert_match Regexp.new('FailureMessagesTest::Foo'), test_result.failures[0].message
  end

  def test_should_display_class_name_and_address_when_expectation_was_on_instance
    test_result = run_as_test do
      Foo.new.expects(:bar)
    end
    assert_match Regexp.new("#<FailureMessagesTest::Foo:#{OBJECT_ADDRESS_PATTERN}>"), test_result.failures[0].message
  end

  def test_should_display_class_name_and_any_instance_prefix_when_expectation_was_on_any_instance
    test_result = run_as_test do
      Foo.any_instance.expects(:bar)
    end
    assert_match Regexp.new('#<AnyInstance:FailureMessagesTest::Foo>'), test_result.failures[0].message
  end

  def test_should_display_mock_name_when_expectation_was_on_named_mock
    test_result = run_as_test do
      foo = mock('foo')
      foo.expects(:bar)
    end
    assert_match Regexp.new('#<Mock:foo>'), test_result.failures[0].message
  end

  def test_should_display_mock_address_when_expectation_was_on_unnamed_mock
    test_result = run_as_test do
      foo = mock
      foo.expects(:bar)
    end
    assert_match Regexp.new("#<Mock:#{OBJECT_ADDRESS_PATTERN}>"), test_result.failures[0].message
  end

  unless Mocha::RUBY_V34_PLUS
    def test_should_display_string_when_expectation_was_on_string
      test_result = run_as_test do
        'Foo'.dup.expects(:bar)
      end
      assert_match Regexp.new(%("Foo")), test_result.failures[0].message
    end
  end

  def test_should_display_that_block_was_expected
    test_result = run_as_test do
      foo = mock
      foo.expects(:bar).with_block_given
    end
    assert_match Regexp.new(' with block given$'), test_result.failures[0].message
  end

  def test_should_display_that_block_was_not_expected
    test_result = run_as_test do
      foo = mock
      foo.expects(:bar).with_no_block_given
    end
    assert_match Regexp.new(' with no block given$'), test_result.failures[0].message
  end
end
