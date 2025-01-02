# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class RespondsLikeTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  # mock

  def test_mock_does_not_respond_when_method_is_not_stubbed
    test_result = run_as_test do
      m = mock
      assert !m.respond_to?(:foo, false)
      assert !m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_raises_unexpected_invocation_exception_when_method_is_not_stubbed
    test_result = run_as_test do
      m = mock
      assert_raises(Minitest::Assertion) { m.foo }
    end
    assert_passed(test_result)
  end

  def test_mock_does_respond_when_method_is_stubbed
    test_result = run_as_test do
      m = mock
      m.stubs(:foo)
      assert m.respond_to?(:foo, false)
      assert m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_does_not_raise_exception_when_method_is_stubbed
    test_result = run_as_test do
      m = mock
      m.stubs(:foo)
      assert_nil m.foo
    end
    assert_passed(test_result)
  end

  # mock which responds like object with public method

  def test_mock_which_responds_like_object_with_public_method_does_respond_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert m.respond_to?(:foo, false)
      assert m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_public_method_raises_unexpected_invocation_exception_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(Minitest::Assertion) { m.foo }
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_public_method_raises_no_method_error_when_another_method_is_invoked
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(NoMethodError) { m.bar }
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_public_method_does_respond_when_method_is_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert m.respond_to?(:foo, false)
      assert m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_public_method_does_not_raise_exception_when_method_is_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert_nil m.foo
    end
    assert_passed(test_result)
  end

  # mock which responds like object with protected method

  def test_mock_which_responds_like_object_with_protected_method_does_not_respond_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert !m.respond_to?(:foo, false)
      assert !m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_protected_method_raises_no_method_error_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(NoMethodError) { m.foo } # vs Minitest::Assertion for public method
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_protected_method_raises_no_method_error_when_another_method_is_invoked
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(NoMethodError) { m.bar }
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_protected_method_does_not_respond_when_method_is_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert !m.respond_to?(:foo, false)
      assert !m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_protected_method_raises_no_method_error_when_method_is_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert_raises(NoMethodError) { m.foo } # vs no exception for public method
    end
    assert_passed(test_result)
  end

  # mock which responds like object with private method

  def test_mock_which_responds_like_object_with_private_method_does_not_respond_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert !m.respond_to?(:foo, false)
      assert !m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_private_method_raises_no_method_error_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(NoMethodError) { m.foo } # vs Minitest::Assertion for public method
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_private_method_raises_no_method_error_when_another_method_is_invoked
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      assert_raises(NoMethodError) { m.bar }
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_private_method_does_not_respond_when_method_is_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert !m.respond_to?(:foo, false)
      assert !m.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_mock_which_responds_like_object_with_private_method_raises_no_method_error_when_method_is_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      m = mock.responds_like(object)
      m.stubs(:foo)
      assert_raises(NoMethodError) { m.foo } # vs no exception for public method
    end
    assert_passed(test_result)
  end

  # object with public method

  def test_object_with_public_method_does_respond_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      assert object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_object_with_public_method_invokes_original_method_when_method_is_not_stubbed
    object = Class.new do
      def foo
        'original'
      end
      public :foo
    end.new
    test_result = run_as_test do
      assert_equal 'original', object.foo
    end
    assert_passed(test_result)
  end

  def test_object_with_public_method_does_respond_when_method_is_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo)
      assert object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_object_with_public_method_invokes_stubbed_method_when_method_is_stubbed
    object = Class.new do
      def foo; end
      public :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo).returns('stubbed')
      assert_equal 'stubbed', object.foo
    end
    assert_passed(test_result)
  end

  # object with protected method

  def test_object_with_protected_method_invokes_stubbed_method_when_method_is_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo).returns('stubbed')
      e = assert_raises(NoMethodError) { object.foo }
      assert_match(/^protected method/, e.message)
      assert_equal 'stubbed', object.send(:foo)
    end
    assert_passed(test_result)
  end

  def test_object_with_protected_method_does_respond_privately_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      assert !object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_object_with_protected_method_invokes_original_method_when_method_is_not_stubbed
    object = Class.new do
      def foo
        'original'
      end
      protected :foo
    end.new
    test_result = run_as_test do
      e = assert_raises(NoMethodError) { object.foo }
      assert_match(/^protected method/, e.message)
      assert_equal 'original', object.send(:foo)
    end
    assert_passed(test_result)
  end

  def test_object_with_protected_method_does_respond_privately_when_method_is_stubbed
    object = Class.new do
      def foo; end
      protected :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo)
      assert !object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  # object with private method

  def test_object_with_private_method_does_respond_privately_when_method_is_not_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      assert !object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_object_with_private_method_invokes_original_method_when_method_is_not_stubbed
    object = Class.new do
      def foo
        'original'
      end
      private :foo
    end.new
    test_result = run_as_test do
      e = assert_raises(NoMethodError) { object.foo }
      assert_match(/^private method/, e.message)
      assert_equal 'original', object.send(:foo)
    end
    assert_passed(test_result)
  end

  def test_object_with_private_method_does_respond_privately_when_method_is_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo)
      assert !object.respond_to?(:foo, false)
      assert object.respond_to?(:foo, true)
    end
    assert_passed(test_result)
  end

  def test_object_with_private_method_invokes_stubbed_method_when_method_is_stubbed
    object = Class.new do
      def foo; end
      private :foo
    end.new
    test_result = run_as_test do
      object.stubs(:foo).returns('stubbed')
      e = assert_raises(NoMethodError) { object.foo }
      assert_match(/^private method/, e.message)
      assert_equal 'stubbed', object.send(:foo)
    end
    assert_passed(test_result)
  end
end
