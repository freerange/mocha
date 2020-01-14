require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)

class StubbingNonPublicInstanceMethodTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_public_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def public_method; end
      public :public_method
    end.new
    test_result = run_as_test do
      instance.stubs(:public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_instance_responds
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def respond_to?(method, _include_private_methods = false)
        (method == :method_to_which_instance_responds)
      end
    end.new
    test_result = run_as_test do
      instance.stubs(:method_to_which_instance_responds)
    end
    assert_passed(test_result)
  end
end

module StubbingNonPublicInstanceMethodSharedTests
  include StubbingNonPublicMethodSharedTests

  def stub_owner
    @stub_owner ||= Class.new.new
  end

  def method_owner
    stub_owner.class
  end
end

class StubbingPrivateInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicInstanceMethodSharedTests

  def visibility
    :private
  end
end

class StubbingProtectedInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicInstanceMethodSharedTests

  def visibility
    :protected
  end
end
