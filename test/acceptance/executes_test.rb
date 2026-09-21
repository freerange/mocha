# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class ExecutesTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_execute_only_the_matching_implementation
    test_result = run_as_test do
      calls = []
      object = mock
      object.expects(:foo).with(1).executes { |value| calls << value; false }.twice
      object.expects(:foo).with(2).executes { |value| calls << value; nil }

      assert_equal [], calls
      assert_equal false, object.foo(1)
      assert_nil object.foo(2)
      assert_equal false, object.foo(1)
      assert_equal [1, 2, 1], calls
    end
    assert_passed(test_result)
  end

  def test_should_execute_for_any_instance
    test_result = run_as_test do
      klass = Class.new do
        def foo(value)
          value
        end
      end
      calls = []
      klass.any_instance.expects(:foo).with(42).executes { |value| calls << value; 'result' }.twice

      assert_equal [], calls
      assert_equal 'result', klass.new.foo(42)
      assert_equal 'result', klass.new.foo(42)
      assert_equal [42, 42], calls
    end
    assert_passed(test_result)
  end

  def test_should_forward_arguments_and_callers_block
    test_result = run_as_test do
      object = Object.new
      object.stubs(:foo).executes do |value, prefix:, &block|
        "#{prefix}#{block.call(value)}"
      end

      assert_equal 'answer: 42', object.foo(42, prefix: 'answer: ', &:to_s)
    end
    assert_passed(test_result)
  end

  def test_should_preserve_positional_hash_arguments
    test_result = run_as_test do
      object = mock
      object.stubs(:foo).executes { |options, &block| [options, block] }

      assert_equal [{ value: 42 }, nil], object.foo({ value: 42 })
    end
    assert_passed(test_result)
  end

  def test_should_compose_with_static_returns_and_exceptions
    test_result = run_as_test do
      object = mock
      object.stubs(:foo).returns('first').then.executes { 'middle' }.then.raises(RuntimeError).then.returns('last')

      assert_equal 'first', object.foo
      assert_equal 'middle', object.foo
      assert_raises(RuntimeError) { object.foo }
      assert_equal 'last', object.foo
      assert_equal 'last', object.foo
    end
    assert_passed(test_result)
  end

  def test_should_repeat_the_final_implementation
    test_result = run_as_test do
      count = 0
      object = mock
      object.stubs(:foo).returns('first').then.executes { count += 1 }

      assert_equal ['first', 1, 2], Array.new(3) { object.foo }
    end
    assert_passed(test_result)
  end

  def test_should_propagate_exceptions_from_the_implementation
    test_result = run_as_test do
      error = Exception.new('boom')
      object = mock
      object.expects(:foo).executes { raise error }

      assert_same error, assert_raises(Exception) { object.foo }
    end
    assert_passed(test_result)
  end

  def test_should_require_an_implementation_block
    test_result = run_as_test do
      expectation = mock.stubs(:foo).returns('original')
      error = assert_raises(ArgumentError) { expectation.executes }
      assert_equal '#executes requires a block', error.message
    end
    assert_passed(test_result)
  end
end
