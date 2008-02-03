require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha'
require 'test_runner'

class StubEverythingAcceptanceTest < Test::Unit::TestCase
  
  include TestRunner

  def test_should_build_stub_and_explicitly_add_an_expectation
    test_result = run_test do
      foo = stub_everything()
      foo.stubs(:bar)
      foo.bar
      foo.unexpected_invocation
    end
    assert_passed(test_result)
  end

  def test_should_build_named_stub_and_explicitly_add_an_expectation
    test_result = run_test do
      foo = stub_everything('foo')
      foo.stubs(:bar)
      foo.bar
      foo.unexpected_invocation
    end
    assert_passed(test_result)
  end

  def test_should_build_stub_incorporating_two_expectations
    test_result = run_test do
      foo = stub_everything(:bar => 'bar', :baz => 'baz')
      foo.bar
      foo.baz
      foo.unexpected_invocation
    end
    assert_passed(test_result)
  end

  def test_should_build_named_stub_incorporating_two_expectations
    test_result = run_test do
      foo = stub_everything('foo', :bar => 'bar', :baz => 'baz')
      foo.bar
      foo.baz
      foo.unexpected_invocation
    end
    assert_passed(test_result)
  end

end