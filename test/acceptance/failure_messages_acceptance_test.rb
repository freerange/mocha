require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha'
require 'test_runner'

class FailureMessagesAcceptanceTest < Test::Unit::TestCase
  
  include TestRunner
  
  class Foo; end

  def test_should_use_class_name_if_receiver_is_class
    test_result = run_test do
      Foo.expects(:bar)
    end
    assert_match Regexp.new('FailureMessagesAcceptanceTest::Foo'), test_result.failures[0].message
  end

  def test_should_use_class_name_if_receiver_is_instance
    test_result = run_test do
      Foo.new.expects(:bar)
    end
    assert_match Regexp.new('<FailureMessagesAcceptanceTest::Foo'), test_result.failures[0].message
  end

  def test_should_use_mock_if_receiver_is_named_mock
    test_result = run_test do
      foo = mock('foo')
      foo.expects(:bar)
    end
    assert_match Regexp.new('<Mock:foo'), test_result.failures[0].message
  end

  def test_should_use_mock_if_receiver_is_unnamed_mock
    test_result = run_test do
      foo = mock()
      foo.expects(:bar)
    end
    assert_match Regexp.new('<Mock:'), test_result.failures[0].message
  end

end